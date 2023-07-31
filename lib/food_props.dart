class FoodProps {
  String food;
  String prob;

  FoodProps({required this.food, required this.prob});

  FoodProps.fromJson(Map<String, dynamic> parsedJSON)
      : food = parsedJSON['food'],
        prob = parsedJSON['probs'];
}