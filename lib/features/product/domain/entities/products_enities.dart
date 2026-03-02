import 'package:equatable/equatable.dart';

class ProductsEnities extends Equatable {
  final int? id;
  final String? title;
  final double? price;
  final String? description;
  final String? category;
  final String? image;
  final RatingEntities? rating;

  ProductsEnities({this.id, this.title, this.price, this.description, this.category, this.image, this.rating});

  @override
  List<Object?> get props => [id, title, price, description, category, image, rating];
}

class RatingEntities extends Equatable {
  final double? rate;
  final int? count;

  RatingEntities({this.rate, this.count});

  @override
  List<Object?> get props => [rate, count];
}
