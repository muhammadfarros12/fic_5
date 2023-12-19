import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecatalog/bloc/add_product/add_product_bloc.dart';
import 'package:flutter_ecatalog/bloc/products/products_bloc.dart';
import 'package:flutter_ecatalog/data/datasource/local_datasource.dart';
import 'package:flutter_ecatalog/data/model/request/product_request_model.dart';
import 'package:flutter_ecatalog/presentation/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController? titleController;
  TextEditingController? priceController;
  TextEditingController? descriptionController;

  final scrollController = ScrollController();

  @override
  void initState() {
    titleController = TextEditingController();
    priceController = TextEditingController();
    descriptionController = TextEditingController();
    context.read<ProductsBloc>().add(GetProductsEvent());
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent == scrollController.offset) {
        context.read<ProductsBloc>().add(GetNextProductsEvent());
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    titleController!.dispose();
    priceController!.dispose();
    descriptionController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        elevation: 5,
        actions: [
          IconButton(
              onPressed: () async {
                await LocalDataSource().removeToken();
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return const LoginPage();
                }));
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          if (state is ProductsLoaded) {
            debugPrint('total data: ${state.model.length}');
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                controller: scrollController,
                itemBuilder: (context, index) {
                  if (state.isNext && index == state.model.length) {
                    return const Card(
                    child: Center(child: CircularProgressIndicator(),)
                  );
                  }
                  return Card(
                    child: ListTile(
                      title: Text(state.model.reversed.toList()[index].title ?? ''),
                      subtitle: Text('${state.model[index].price}\$'),
                    ),
                  );
                },
                itemCount: state.isNext ? state.model.length + 1 : state.model.length,
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Add Product'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(labelText: 'Title'),
                      ),
                      TextField(
                        controller: priceController,
                        decoration: const InputDecoration(labelText: 'Price'),
                      ),
                      TextField(
                        controller: descriptionController,
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                      ),
                    ],
                  ),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel')),
                    const SizedBox(
                      width: 30,
                    ),
                    BlocConsumer<AddProductBloc, AddProductState>(
                      listener: (context, state) {
                        if (state is AddProductLoaded) {
                          ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Add product success'),
                          ),
                        );
                        context.read<ProductsBloc>().add(GetProductsEvent());
                        titleController!.clear();
                        priceController!.clear();
                        descriptionController!.clear();
                        Navigator.pop(context);  
                        }
                        if (state is AddProductError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Add product: ${state.message}'),
                          ),
                        );
                        }
                        
                      },
                      builder: (context, state) {
                        if (state is AddProductLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ElevatedButton(
                            onPressed: () {
                              final model = ProductRequestModel(
                                title: titleController!.text,
                                price: int.parse(priceController!.text),
                                description: descriptionController!.text,
                              );
                              context
                                  .read<AddProductBloc>()
                                  .add(DoAddProductEvent(model: model));
                            },
                            child: const Text('Add'));
                      },
                    ),
                  ],
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
