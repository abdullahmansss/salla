abstract class SingleCategoryStates {}

class SingleCategoryInitialState extends SingleCategoryStates {}

class SingleCategoryLoadingState extends SingleCategoryStates {}

class SingleCategorySuccessState extends SingleCategoryStates {}

class SingleCategoryErrorState extends SingleCategoryStates
{
  final String error;

  SingleCategoryErrorState(this.error);
}