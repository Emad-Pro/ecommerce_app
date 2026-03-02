import 'package:ecommerce_app/features/product/domain/entities/products_enities.dart';

class ProductModel extends ProductsEnities {
  ProductModel({super.id, super.title, super.price, super.description, super.category, super.image, super.rating});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],

      price: (json['price'] as num?)?.toDouble(),
      description: json['description'],
      category: json['category'],
      image: json['image'],

      rating: json['rating'] != null ? RatingModel.fromJson(json['rating']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,

      'rating': rating != null ? (rating as RatingModel).toJson() : null,
    };
  }
}

class RatingModel extends RatingEntities {
  RatingModel({super.rate, super.count});

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(rate: (json['rate'] as num?)?.toDouble(), count: json['count']);
  }

  Map<String, dynamic> toJson() {
    return {'rate': rate, 'count': count};
  }
}
