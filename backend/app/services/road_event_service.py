import logging
from typing import List, Optional, Dict, Any

from pydantic import BaseModel

from app.config import (
    SUPABASE_URL,
    SUPABASE_SERVICE_ROLE_KEY,
)

logger = logging.getLogger("road_event_service")


class ActiveSegmentRestriction(BaseModel):
    segment_id: Optional[str] = None
    road_event_id: Optional[str] = None
    osm_way_id: int
    is_closed: bool = False
    penalty_seconds: float = 0.0
    event_type: Optional[str] = None


class RoadEventService:
    """
    Service to fetch active road-event routing restrictions from Supabase.

    The routing-specific view v_active_routing_segments is used as the
    single source for active restrictions.
    """

    def __init__(
        self,
        supabase_url: Optional[str] = None,
        supabase_key: Optional[str] = None,
    ):
        self.supabase_url = supabase_url or SUPABASE_URL
        self.supabase_key = supabase_key or SUPABASE_SERVICE_ROLE_KEY
        self.client = None

        if self.supabase_url and self.supabase_key:
            try:
                from supabase import create_client

                self.client = create_client(
                    self.supabase_url,
                    self.supabase_key,
                )

                logger.info("Supabase client initialized successfully.")

            except Exception as e:
                logger.warning(
                    f"Failed to initialize Supabase client: {e}"
                )

        else:
            logger.warning(
                "Supabase URL or Key not configured; "
                "running in offline/local mode."
            )

    def is_connected(self) -> bool:
        return self.client is not None

    def fetch_active_restrictions(
        self,
    ) -> List[ActiveSegmentRestriction]:
        """
        Fetch all active routing restrictions from
        v_active_routing_segments.

        The view already joins road_event_segments,
        road_events, and event_types and filters for
        active road events.
        """

        if not self.client:
            logger.debug(
                "No Supabase client available. "
                "Returning empty restrictions."
            )
            return []

        try:
            response = (
                self.client
                .from_("v_active_routing_segments")
                .select("*")
                .execute()
            )

            rows = response.data if hasattr(response, "data") else []

            restrictions: List[ActiveSegmentRestriction] = []

            for row in rows:
                restriction = self._parse_restriction_row(row)

                if restriction:
                    restrictions.append(restriction)

            logger.info(
                "Loaded %d active routing restrictions.",
                len(restrictions),
            )

            return restrictions

        except Exception as error:
            logger.error(
                "Failed to fetch active routing restrictions: %s",
                error,
            )
            return []

    def _parse_restriction_row(
        self,
        row: Dict[str, Any],
    ) -> Optional[ActiveSegmentRestriction]:
        raw_osm = row.get("osm_way_id")

        if raw_osm is None:
            return None

        try:
            osm_way_id = int(raw_osm)

        except (ValueError, TypeError):
            return None

        is_closed = bool(
            row.get("is_closed", False)
        )

        raw_weight = row.get("weight_modifier")

        if raw_weight is not None:
            try:
                penalty_seconds = max(
                    0.0,
                    float(raw_weight),
                )
            except (ValueError, TypeError):
                penalty_seconds = 0.0
        else:
            penalty_seconds = 0.0

        return ActiveSegmentRestriction(
            segment_id=str(
                row.get("segment_id")
                or row.get("id")
                or ""
            ),
            road_event_id=str(
                row.get("road_event_id")
                or ""
            ),
            osm_way_id=osm_way_id,
            is_closed=is_closed,
            penalty_seconds=penalty_seconds,
            event_type=row.get("event_type"),
        )