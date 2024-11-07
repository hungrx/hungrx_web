abstract class AddCategoryEvent {}

class AddNewCategory extends AddCategoryEvent {
  final String name;

  AddNewCategory({required this.name});
}