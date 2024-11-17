import 'dart:typed_data';
import 'package:hungrx_web/data/models/menu_models/dish_edit_model.dart';

abstract class DishEditEvent {}

class DishEditSubmitted extends DishEditEvent {
  final DishEditModel dish;
  final Uint8List? imageBytes;
  final String? imageName;

  DishEditSubmitted({
    required this.dish,
    this.imageBytes,
    this.imageName,
  });
}