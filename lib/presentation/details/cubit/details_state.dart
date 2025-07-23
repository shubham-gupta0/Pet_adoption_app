part of 'details_cubit.dart';

class DetailsState extends Equatable {
  final bool isAdopted;
  final bool isFavorite;

  const DetailsState({
    this.isAdopted = false,
    this.isFavorite = false,
  });

  DetailsState copyWith({
    bool? isAdopted,
    bool? isFavorite,
  }) {
    return DetailsState(
      isAdopted: isAdopted ?? this.isAdopted,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object> get props => [isAdopted, isFavorite];
}