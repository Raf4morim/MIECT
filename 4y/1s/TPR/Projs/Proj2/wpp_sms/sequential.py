import requests
import time
import random
import threading

def send_message(chat_id, text):
    """
    Send message to chat_id.
    :param chat_id: Phone number + "@c.us" suffix - 1231231231@c.us
    :param text: Message for the recipient
    """
    # Send a text message via WhatsApp HTTP API
    response = requests.post(
        "http://localhost:3000/api/sendText",
        json={
            "chatId": chat_id,
            "text": text,
            "session": "default",
        },
    )
    response.raise_for_status()

# List of contacts to send messages to
contacts = [
    "351914411549"
]

# Function to wait for user input
def wait_for_input():
    input("Press Enter to stop sending messages...\n")
    print("Stopping message sending...")
    # Terminate the program after Enter is pressed
    raise SystemExit

# Start a thread to wait for user input in the background
input_thread = threading.Thread(target=wait_for_input)
input_thread.daemon = True  # Mark the thread as a daemon so it can be stopped
input_thread.start()

message_counter = 0

while True:
    interval_seconds = random.randint(1, 3)
    if not input_thread.is_alive():
        break

    if message_counter == 10:
        print("Pausing for 15 seconds...")
        time.sleep(15)
        message_counter = 0  # Reset the counter after the pause

    contact = random.choice(contacts)
    message_length = random.choices([random.randint(50, 100), random.randint(101, 500)], weights=[0.6, 0.4])[0]
    # Create a message with random characters of the defined length
    message = ''.join(random.choices('abcdefghijklmnopqrstuvwxyz ', k=message_length))
    # Send the message to the selected contact
    send_message(chat_id=f"{contact}@c.us", text=message)
    message_counter += 1  # Increment message counter

    # Wait for the delay before sending the next message
    time.sleep(interval_seconds)
