import 'package:hungrx_web/data/models/menu_models/menu_model.dart';

abstract class MenuState {}

class MenuInitial extends MenuState {}

class MenuLoading extends MenuState {}

class MenuLoaded extends MenuState {
  final MenuResponse menu;
  MenuLoaded(this.menu);
}

class MenuEmpty extends MenuState {
  final String message;
  MenuEmpty(this.message);
}

class MenuError extends MenuState {
  final String message;
  MenuError(this.message);
}