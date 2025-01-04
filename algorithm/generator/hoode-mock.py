import json
import mimetypes
import random
import requests
from faker import Faker
from datetime import datetime
import os
import decimal

fake = Faker()

def authenticate(base_url, admin_email, admin_password):
    url = f"{base_url}/api/admins/auth-with-password"
    try:
        response = requests.post(url, json={"identity": admin_email, "password": admin_password})
        response.raise_for_status()
        return response.json()["token"]
    except requests.exceptions.HTTPError as http_err:
        raise Exception(f"HTTP error occurred: {http_err}  URL: {url}") from http_err
    except requests.exceptions.RequestException as req_err:
        raise Exception(f"An error occurred during the request: {req_err}") from req_err
    except KeyError as key_err:
        raise Exception(f"Unexpected response format. Missing key: {key_err}") from key_err
    except Exception as e:
        raise Exception(f"An unexpected error occurred: {e}") from e

def get_files_from_folder(folder):
    files = []
    for filename in os.listdir(folder):
        filepath = os.path.join(folder, filename)
        if os.path.isfile(filepath):
            mime_type, _ = mimetypes.guess_type(filepath)
            if mime_type:
                files.append({"path": filepath, "mime_type": mime_type})
    return files

def generate_users(count, avatars):
    users = []
    for _ in range(count):
        is_agent = fake.boolean()
        user = {
            "address": fake.address(),
            "email": fake.email(),
            "country": fake.country(),
            "longitude": fake.longitude(),
            "latitude": fake.latitude(),
            "is_agent": is_agent,
            "date_of_birth": fake.date_of_birth().isoformat(),
            "first_name": fake.first_name(),
            "last_name": fake.last_name(),
            "username": fake.user_name(),
            "password": "12345678",  # Ensure password meets requirements
            "passwordConfirm": "12345678",  # Match password confirmation
            "agent_status": random.choice(["active", "pending", "inactive"]),
            "avatar": random.choice(avatars),
        }
        # Validation logging
        assert "password" in user and "passwordConfirm" in user, f"User missing password fields: {user}"
        users.append(user)
    return users


def generate_agents(users, count, avatars):
    # Filter agent users and ensure we have at least one
    agent_users = [user for user in users if user.get("is_agent")]
    if not agent_users:
        print("No agent users available. Creating one agent user...")
        agent_user = users[0] if users else None
        if agent_user:
            agent_user["is_agent"] = True
            agent_users = [agent_user]
        else:
            return []

    agents = []
    for _ in range(count):
        agent_user = random.choice(agent_users)
        agents.append({
            "agent_name": f"{fake.first_name()} {fake.last_name()}",
            "agent_title": fake.job(),
            "bio": fake.text(max_nb_chars=200),
            "specialiazion": random.sample(["residential", "commercial", "luxury"], random.randint(1, 3)),
            "contact": {"phone": fake.phone_number(), "email": fake.email()},
            "total_listings": random.randint(1, 100),
            "avatar": random.choice(avatars),
            "user": agent_user["email"],
        })
    return agents


def generate_properties(agents, count, images):
    properties = []
    for _ in range(count):
        agent = random.choice(agents)
        properties.append({
            "title": fake.catch_phrase(),
            "price": random.randint(50000, 1000000),
            "description": fake.text(max_nb_chars=300),
            "address": fake.address(),
            "images": random.sample(images, random.randint(1, 3)),
            "category": random.choice(["hotel", "house", "apartment", "villa", "office", "store", "penthouse", "guesthouse"]),
            "type": random.choice(["rent", "sale", "lease"]),
            "longitude": fake.longitude(),
            "latitude": fake.latitude(),
            "country": fake.country(),
            "state": fake.state(),
            "city": fake.city(),
            "status": random.choice(["available", "sold", "booked"]),
            "agent": agent["agent_name"],
        })
    return properties

def custom_json_encoder(obj):
    if isinstance(obj, decimal.Decimal):
        return float(obj)
    raise TypeError(f"Object of type {obj.__class__.__name__} is not JSON serializable")

def populate_database_with_return(base_url, token, collection, data):
    url = f"{base_url}/api/collections/{collection}/records"
    headers = {"Authorization": f"Bearer {token}"}
    created_records = []

    for record in data:
        files_to_upload = {}
        record_data = record.copy()

        # Handle file fields
        for key, value in list(record_data.items()):
            if isinstance(value, dict) and "path" in value and "mime_type" in value:
                files_to_upload[key] = (os.path.basename(value["path"]), value["path"], value["mime_type"])
                del record_data[key]
                record_data[key] = []

        # Prepare form data with all fields
        form_data = {
            "username": record_data.get("username"),
            "email": record_data.get("email"),
            "emailVisibility": True,
            "password": "12345678",
            "passwordConfirm": "12345678",
            "first_name": record_data.get("first_name"),
            "last_name": record_data.get("last_name"),
            "address": record_data.get("address"),
            "country": record_data.get("country"),
            "longitude": record_data.get("longitude"),
            "latitude": record_data.get("latitude"),
            "is_agent": record_data.get("is_agent"),
            "date_of_birth": record_data.get("date_of_birth"),
            "agent_status": record_data.get("agent_status")
        }

        # Convert form data to JSON string
        form_data = {"data": json.dumps(form_data, default=custom_json_encoder)}

        # Add password fields at root level for users collection
        if collection == "users":
            form_data["password"] = "12345678"
            form_data["passwordConfirm"] = "12345678"

        files = {
            key: (filename, open(path, 'rb'), mime_type) 
            for key, (filename, path, mime_type) in files_to_upload.items()
        }

        try:
            response = requests.post(url, files=files, data=form_data, headers=headers)
            if response.status_code == 200:
                created_records.append(response.json())
            else:
                print(f"Failed to create record: {response.json()}")
        finally:
            for file_tuple in files.values():
                file_tuple[1].close()

    return created_records




def main():
    avatars_folder = "avatars"
    images_folder = "images"
    
    if not os.path.exists(avatars_folder) or not os.path.exists(images_folder):
        print(f"Make sure folders '{avatars_folder}' and '{images_folder}' exist and contain the required files.")
        return
    
    avatars = get_files_from_folder(avatars_folder)
    images = get_files_from_folder(images_folder)
    
    base_url = input("Enter PocketBase base URL: ")
    admin_email = input("Enter admin email: ")
    admin_password = input("Enter admin password: ")
    token = authenticate(base_url, admin_email, admin_password)
    
    user_count = int(input("Enter the number of users to generate: "))
    agent_count = int(input("Enter the number of agents to generate: "))
    property_count = int(input("Enter the number of properties to generate: "))
    
    # First create users
    users = generate_users(user_count, avatars)
    created_users = populate_database_with_return(base_url, token, "users", users)
    
    # Make sure we have successfully created users
    if not created_users:
        print("No users were created successfully. Please check user creation.")
        return
        
    user_id_map = {user["email"]: user["id"] for user in created_users if "id" in user}
    
    # Generate and filter agents
    agents = generate_agents(created_users, agent_count, avatars)  # Use created_users instead of users
    valid_agents = [agent for agent in agents if agent["user"] in user_id_map]
    
    if not valid_agents:
        print("No valid agents could be created. Please check agent creation.")
        return
        
    # Continue with valid agents
    for agent in valid_agents:
        agent["user"] = user_id_map[agent["user"]]
    created_agents = populate_database_with_return(base_url, token, "agents", valid_agents)
    
    # Only proceed with properties if we have agents
    if created_agents:
        agent_id_map = {agent["agent_name"]: agent["id"] for agent in created_agents}
        properties = generate_properties(created_agents, property_count, images)
        for property_ in properties:
            property_["agent"] = agent_id_map[property_["agent"]]
        populate_database_with_return(base_url, token, "properties", properties)
        print("Database population complete.")
    else:
        print("No properties were created as no agents were available.")

if __name__ == "__main__":
    main()
