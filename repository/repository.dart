import 'package:hive/hive.dart';

// I : id_type , D : data_type
class Repository<I, D> {
  final String name;
  late Box<D> box; // Đánh dấu box là 'late' để khai báo sau

  Repository({required this.name});

  // Phương thức khởi tạo để mở hộp
  Future<void> init() async {
    if (!Hive.isBoxOpen(name)) {
      box = await Hive.openBox<D>(name); // Chờ mở hộp và gán vào biến box
    } else {
      box = Hive.box(name);
    }
  }

  // Phương thức để lấy tất cả dữ liệu
  Future<List<D>> getAll() async {
    return box.values.toList(); // Trả về danh sách các giá trị
  }

  // Phương thức lấy dữ liệu theo id, nếu không tìm thấy thì ném lỗi
  Future<D> getById(I id) async {
    final data = box.get(id);
    if (data == null) {
      throw Exception('Dữ liệu với id $id không tồn tại');
    }
    return data; // Trả về dữ liệu nếu tồn tại
  }

  // Phương thức thêm dữ liệu
  Future<void> add(I id, D data) async {
    await box.put(id, data); // Thêm dữ liệu với id
  }

  // Phương thức xóa dữ liệu
  Future<void> delete(I id) async {
    await box.delete(id); // Xóa dữ liệu với id
  }

  // Phương thức cập nhật dữ liệu
  Future<void> update(I id, D data) async {
    await box.put(id, data); // Cập nhật dữ liệu với id
  }

  // Phương thức kiểm tra xem liệu dữ liệu có tồn tại hay không
  Future<bool> exists(I id) async {
    return box.containsKey(id); // Trả về true nếu dữ liệu tồn tại
  }

// Phương thức lấy dữ liệu theo chỉ số (index)
  Future<D> getAt(int index) async {
    if (index < 0 || index >= box.length) {
      throw Exception('Chỉ số $index nằm ngoài phạm vi.');
    }

    final data = box.getAt(index); // Lấy dữ liệu tại chỉ số

    if (data == null) {
      throw Exception(
          'Không tìm thấy dữ liệu tại chỉ số $index.'); // Ném ngoại lệ nếu không có dữ liệu
    }

    return data; // Trả về dữ liệu nếu tồn tại
  }



  Future<void> clearAll() async {
    await box.clear(); // Xóa tất cả dữ liệu trong box
  }

  Future<int> count() async {
    return await box.length;
  }

  Future<void> add_all(List<D> list) async {
    await box.addAll(list);
    return;
  }
}
