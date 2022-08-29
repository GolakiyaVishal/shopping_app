import 'package:bloc/bloc.dart';
import 'package:shopping_app/presentation/item_list/add_new_item/add_new_item_state.dart';

class AddNewItemCubit extends Cubit<AddNewItemState> {
  AddNewItemCubit() : super(const AddNewItemState.empty());

  void updateAddButton(String? text){
    emit(state.copyWith(canAddItem: text?.isNotEmpty??false));
  }
}
