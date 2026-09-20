import socket
import threading

from zeroconf import ServiceInfo, Zeroconf


class MdnsService:
    def __init__(self):
        self.zeroconf = None
        self.info = None
        self.thread = None
        self.ready = threading.Event()

    def start(self):
        self.thread = threading.Thread(
            target=self._register,
            daemon=True,
        )
        self.thread.start()

        if not self.ready.wait(timeout=5):
            raise RuntimeError("mDNS service registration timed out")

    def _register(self):
        try:
            ip = self._get_local_ip()

            self.zeroconf = Zeroconf()

            self.info = ServiceInfo(
                "_maargsaarthi._tcp.local.",
                "MaargSaarthi Backend._maargsaarthi._tcp.local.",
                addresses=[socket.inet_aton(ip)],
                port=8000,
                properties={
                    "service": "routing",
                    "version": "1",
                },
            )

            self.zeroconf.register_service(self.info)

            print(f"mDNS service registered: {ip}:8000")
        finally:
            self.ready.set()

    def stop(self):
        if self.thread is not None:
            self.thread.join(timeout=2)

        if self.zeroconf is not None:
            if self.info is not None:
                self.zeroconf.unregister_service(self.info)

            self.zeroconf.close()
            self.zeroconf = None
            self.info = None

            print("mDNS service stopped")

    def _get_local_ip(self):
        sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

        try:
            sock.connect(("8.8.8.8", 80))
            return sock.getsockname()[0]
        finally:
            sock.close()