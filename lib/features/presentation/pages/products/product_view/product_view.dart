import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fork_and_fusion_admin/core/shared/constants.dart';
import 'package:fork_and_fusion_admin/core/utils/utils.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/product.dart';


class ProductView extends StatelessWidget {
  ProductEntity data;
  ProductView({super.key, required this.data});
  var gap = const SizedBox(height: 10);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [_buildBody(context), _buildImage(), _popButton(context)],
      ),
    );
  }

  Align _buildBody(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Material(
        elevation: 10,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        child: Container(
          padding: Constants.padding15,
          height: Constants.dHeight * .73,
          child: ListView(
            children: [
              SizedBox(height: Constants.dHeight * 0.02),
              _buildnameAndPrice(context),
              gap,
              _ingredientsWidget(context),
              gap,
              _labelChipBox(
                context: context,
                title: "Category",
                list: Utils.extractCategoryNames(data.category),
              ),
              gap,
              Visibility(
                visible: data.price == 0,
                child: _labelChipBox(
                  title: 'Variants',
                  context: context,
                  list: extractVariants(data.variants),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Column _labelChipBox({
    required String title,
    required BuildContext context,
    required List<String> list,
  }) {
    return Column(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        gap,
        Wrap(
          runSpacing: 10,
          spacing: 10,
          children: List.generate(
            list.length,
            (index) => Material(
              borderRadius: Constants.radius,
              color: Theme.of(context).colorScheme.tertiary,
              elevation: 10,
              child: Container(
                padding: Constants.padding10,
                child: Text(list[index]),
              ),
            ),
          ),
        )
      ],
    );
  }

  Material _ingredientsWidget(BuildContext context) {
    return Material(
      borderRadius: Constants.radius,
      elevation: 10,
      color: Theme.of(context).colorScheme.tertiary,
      child: Container(
        padding: Constants.padding15,
        child: Column(
          children: [
            Text('Ingredients',
                style: Theme.of(context).textTheme.headlineSmall),
            Text(data.ingredients),
          ],
        ),
      ),
    );
  }

  Row _buildnameAndPrice(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          Utils.capitalizeEachWord(data.name),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Visibility(
          visible: data.price != 0,
          child: Text(
            "₹ ${data.price}",
          ),
        )
      ],
    );
  }

  SafeArea _popButton(BuildContext context) {
    return SafeArea(
      child: IconButton(
        onPressed: () =>Navigator.of(context).pop(),
        icon: Icon(
          Icons.arrow_back,
          color: Theme.of(context).colorScheme.tertiary,
        ),
      ),
    );
  }

  Container _buildImage() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30)),
          image: DecorationImage(
              fit: BoxFit.cover,
              image: CachedNetworkImageProvider(data.image))),
      height: Constants.dHeight * .33,
    );
  }

  List<String> extractVariants(Map<String, dynamic> map) {
    var keys = map.keys;
    List<String> data = keys.map((e) => '$e  : ₹ ${map[e]}').toList();
    return data;
  }
}