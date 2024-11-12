abstract class MenuEvent {}

class FetchMenu extends MenuEvent {
  final String restaurantId;
  FetchMenu(this.restaurantId);
}
