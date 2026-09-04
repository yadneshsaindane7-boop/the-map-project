import os
from pathlib import Path
from dotenv import load_dotenv

BACKEND_DIR = Path(__file__).resolve().parent.parent

# Load .env file from backend directory if present, otherwise mobile .env
env_file = BACKEND_DIR / ".env"
if env_file.exists():
    load_dotenv(env_file)
else:
    mobile_env = BACKEND_DIR.parent / "apps" / "mobile" / ".env"
    if mobile_env.exists():
        load_dotenv(mobile_env)

SUPABASE_URL = os.getenv("SUPABASE_URL", "")
SUPABASE_SERVICE_ROLE_KEY = os.getenv("SUPABASE_SERVICE_ROLE_KEY") or os.getenv("SUPABASE_ANON_KEY", "")

# Database road_event_segments semantics:
# - is_closed: boolean (True means road is blocked)
# - weight_modifier: integer/float (additive travel-time delay in seconds)


