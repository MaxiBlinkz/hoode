# Generate sample data
data_generator = PropertyDataGenerator()
sample_properties = data_generator.generate_sample_properties(1000)

# Train the model
model_trainer = PropertyModelTrainer()
model_trainer.train_model(sample_properties)

# Create recommender with trained model
recommender = PropertyRecommender(model_trainer)

# Get recommendations
recommendations = recommender.get_recommendations(
    user_id="sample_user",
    properties_df=sample_properties,
    user_lat=40.7128,
    user_lon=-74.0060
)

# Update model with new data
new_properties = data_generator.generate_sample_properties(100)
model_trainer.update_model(new_properties)
