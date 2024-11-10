import 'dart:async';
import 'dart:io';

// Model Data
class Product {
  final String productName;
  final double price;
  final bool inStock;

  Product(this.productName, this.price, this.inStock);

  @override
  String toString() => "$productName - Rp$price (Stok: ${inStock ? 'Tersedia' : 'Habis'})";
}

class User {
  final String name;
  final int age;
  late final List<Product> products;
  Role? role;

  User(this.name, this.age) {
    products = [];
  }

  void viewProducts() {
    if (products.isEmpty) {
      print("Tidak ada produk yang tersedia.");
    } else {
      print("Daftar Produk untuk $name:");
      for (var product in products) {
        print(product);
      }
    }
  }
}

// Enum Role
enum Role { Admin, Customer }

// Subclass AdminUser dan CustomerUser
class AdminUser extends User {
  AdminUser(String name, int age) : super(name, age) {
    role = Role.Admin;
  }

  void addProduct(Product product) {
    if (!product.inStock) {
      print("Produk ${product.productName} tidak tersedia dalam stok.");
      return;
    }

    // Menggunakan Set untuk memastikan produk unik
    var uniqueProducts = products.toSet();
    if (uniqueProducts.add(product)) {
      products.add(product);
      print("Produk ${product.productName} berhasil ditambahkan.");
    } else {
      print("Produk ${product.productName} sudah ada dalam daftar.");
    }
    viewProducts(); // Tampilkan daftar produk setelah menambah produk
  }

  void removeProduct(String productName) {
    final initialLength = products.length;
    products.removeWhere((product) => product.productName == productName);

    if (products.length < initialLength) {
      print("Produk $productName berhasil dihapus.");
    } else {
      print("Produk $productName tidak ditemukan dalam daftar.");
    }
    viewProducts(); // Tampilkan daftar produk setelah menghapus produk
  }
}

class CustomerUser extends User {
  CustomerUser(String name, int age) : super(name, age) {
    role = Role.Customer;
  }

  // Customer hanya bisa melihat produk yang ada
}

Future<void> fetchProductDetails() async {
  print("Mengambil data produk dari server...");
  await Future.delayed(Duration(seconds: 2));
  print("Data produk berhasil diambil.");
}

// Fungsi untuk menambah produk melalui input pengguna
void adminAddProduct(AdminUser admin) {
  print("\n--- Tambah Produk ---");
  stdout.write("Nama Produk: ");
  String? productName = stdin.readLineSync();

  if (productName == null || productName.isEmpty) {
    print("Nama produk tidak boleh kosong.");
    return;
  }

  stdout.write("Harga Produk: ");
  double? price = double.tryParse(stdin.readLineSync() ?? '');

  if (price == null) {
    print("Harga produk tidak valid.");
    return;
  }

  stdout.write("Stok (true untuk tersedia, false untuk habis): ");
  bool inStock = stdin.readLineSync()?.toLowerCase() == 'true';

  var newProduct = Product(productName, price, inStock);
  admin.addProduct(newProduct);
}

// Fungsi untuk menghapus produk melalui input pengguna
void adminRemoveProduct(AdminUser admin) {
  print("\n--- Hapus Produk ---");
  stdout.write("Nama Produk yang akan dihapus: ");
  String? productName = stdin.readLineSync();

  if (productName == null || productName.isEmpty) {
    print("Nama produk tidak boleh kosong.");
    return;
  }

  admin.removeProduct(productName);
}

void main() async {
  // Membuat user Admin dan Customer
  var admin = AdminUser("Budi", 30);
  var customer = CustomerUser("Siti", 25);

  // Menambahkan beberapa produk untuk admin
  admin.addProduct(Product("Laptop", 10000, true));
  admin.addProduct(Product("Smartphone", 5000, true));
  admin.addProduct(Product("Tablet", 3000, false)); // Produk habis

  // Menu loop untuk admin dan customer
  bool running = true;
  while (running) {
    print("\n--- Menu ---");
    print("1. Admin: Tambah Produk");
    print("2. Admin: Hapus Produk");
    print("3. Admin: Lihat Daftar Produk");
    print("4. Customer: Lihat Produk");
    print("5. Keluar");
    stdout.write("Pilih opsi: ");
    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        adminAddProduct(admin);
        break;
      case '2':
        adminRemoveProduct(admin);
        break;
      case '3':
        print("\nDaftar Produk Admin:");
        admin.viewProducts(); // Admin melihat produk
        break;
      case '4':
        print("\nDaftar Produk Customer:");
        customer.viewProducts(); // Customer melihat produk
        break;
      case '5':
        running =false;
        print("Keluar dari menu.");
        break;
      default:
        print("Pilihan tidak valid, coba lagi.");
    }
  }

  // Fetch data produk secara asynchronous
  await fetchProductDetails();
}

