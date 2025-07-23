import 'package:injectable/injectable.dart';
import 'package:pet_adoption_app/domain/entities/pet.dart';
import 'package:pet_adoption_app/domain/repositories/pet_repository.dart';

@injectable
class GetPetsUseCase {
  final PetRepository _repository;

  GetPetsUseCase(this._repository);

  Future<List<Pet>> call({int page = 0, int limit = 10}) async {
    // await Future.delayed(const Duration(seconds: 2));
    return await _repository.getPets(page: page, limit: limit);
  }
}
