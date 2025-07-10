import time
from agora_token_builder import RtcTokenBuilder

def generate_agora_token(channel_name: str, uid: int = 0):
    app_id = "71ecc755b7734f29a9b621718daa394e"
    app_cert = "39d164570143478aaabf4c4271438c52"

    # Maximum expire_seconds jo 32-bit unsigned integer ki limit mein fit ho sake
    # Current timestamp (approx. 1752066594) ko 4294967295 se minus karein
    # Is tarah aapko maximum allowed seconds mil jayenge
    max_allowed_expire_seconds = 2542900701 # Takreeban 80 saal

    expire_timestamp = int(time.time()) + max_allowed_expire_seconds

    # Debugging ke liye values print karein
    print(f"DEBUG: Calculated expire_timestamp: {expire_timestamp}")
    print(f"DEBUG: Max allowed timestamp for 32-bit unsigned int: 4294967295")

    return RtcTokenBuilder.buildTokenWithUid(
        app_id, app_cert, channel_name, uid, 1, expire_timestamp
    )