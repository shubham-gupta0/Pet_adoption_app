import 'package:injectable/injectable.dart';
import 'package:pet_adoption_app/domain/repositories/pet_repository.dart';

@injectable
class AdoptPetUseCase {
  final PetRepository _repository;

  AdoptPetUseCase(this._repository);

  Future<void> call(String petId) async {
    await _repository.adoptPet(petId);
  }
}
