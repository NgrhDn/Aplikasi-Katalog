import '../data/products_data.dart';
import '../models/product.dart';

class HomeController {
  final List<Product> products = generateProducts();

  int currentTabIndex = 0;

  void changeTab(int index) {
    currentTabIndex = index;
  }
  
}
