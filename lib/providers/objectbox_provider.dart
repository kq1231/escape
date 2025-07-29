import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../objectbox.g.dart'; // Will be generated after running build_runner,
//  Inshaa Allah

part 'objectbox_provider.g.dart';

class ObjectBox {
  /// The Store of this app.
  late final Store store;

  ObjectBox._create(this.store) {
    // Add any additional setup code, e.g. build queries.
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
    final store = await openStore(directory: p.join(docsDir.path, "escape-db"));
    return ObjectBox._create(store);
  }
}

@Riverpod(keepAlive: true)
Future<ObjectBox> objectbox(Ref ref) async {
  // This will be injected in main.dart
  return await ObjectBox.create();
}
