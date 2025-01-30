from property_data_generator import PropertyDataGenerator
from property_model_trainer import PropertyModelTrainer
from property_recommender import PropertyRecommender
import random

def test_model_recommendations():
    # Initialize components
    print("Starting model training and testing pipeline...")
    generator = PropertyDataGenerator()
    trainer = PropertyModelTrainer()
    
    # Generate and split data
    print("Generating sample property data...")
    training_properties = generator.generate_sample_properties(num_samples=2000)
    test_properties = generator.generate_sample_properties(num_samples=500)
    
    # Train model
    print("Training model with sample data...")
    training_score = trainer.train_model(training_properties)
    print(f"Initial training score: {training_score}")
    
    # Test recommendations
    print("\nTesting recommendation system...")
    recommender = PropertyRecommender(trainer)
    
    # Test cases
    test_cases = [
        ("user1", 40.7128, -74.0060),  # New York coordinates
        ("user2", 34.0522, -118.2437),  # Los Angeles coordinates
        ("", 0.0, 0.0),  # Anonymous user, no location
    ]
    
    for user_id, lat, lon in test_cases:
        print(f"\nTest case - User: {user_id or 'Anonymous'}, Location: {'Specified' if lat != 0.0 else 'None'}")
        recommendations = recommender.get_recommendations(
            user_id=user_id,
            properties_df=test_properties,
            user_lat=lat,
            user_lon=lon,
            n_recommendations=5
        )
        print(f"Number of recommendations: {len(recommendations)}")
        print("Sample recommendation features:")
        print(recommendations[['price', 'bedrooms', 'bathrooms', 'rating']].head())
    
    # Update and test model with new data
    print("\nUpdating model with new data...")
    update_score = trainer.update_model(test_properties)
    print(f"Model update score: {update_score}")

if __name__ == "__main__":
    test_model_recommendations()
