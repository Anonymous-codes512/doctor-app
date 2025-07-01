import base64
from Crypto.Cipher import AES
from Crypto.Random import get_random_bytes

def generate_aes_key():
    key = get_random_bytes(32)  # 256-bit AES key
    return base64.b64encode(key).decode('utf-8')  # send/store as string
