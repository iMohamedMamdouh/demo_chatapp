import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_chatapp/constants.dart';
import 'package:demo_chatapp/models/message.dart';
import 'package:meta/meta.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessagesCollection);

  void sendMessage({required String message, required String email}) {
    try {
      messages.add({
        kMessage: message,
        kCreatedAt: DateTime.now(),
        'id': email,
      });
    } on Exception catch (e) {
      // TODO
    }
  }

  void getMessages() {
    messages.orderBy(kCreatedAt, descending: true).snapshots().listen(
      (event) {
        List<Message> messagesList = [];

        for (var doc in event.docs) {
          messagesList.add(Message.fromJson(doc));
        }

        emit(ChatSuccess(message: messagesList));
      },
    );
  }
}
