import 'package:deart/controllers/vehicle_controller.dart';
import 'package:deart/models/enums/car_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CarImageWidget extends GetView<VehicleController> {
  const CarImageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<VehicleController>(
      builder: (controller) {
        return Image.asset(
          _getAssetName(controller.carModel.value),
        );
      },
    );

    // child: SvgPicture.asset(
    //   'assets/images/upper_view.svg',
    //   semanticsLabel: 'Upper view',
    // ),
  }

  String _getAssetName(CarModel carModel) {
    switch (carModel) {
      case CarModel.model3BlackBlack:
        return 'assets/images/model3_black_black_uv.png';
      case CarModel.model3BlackWhite:
        return 'assets/images/model3_black_white_uv.png';
      case CarModel.model3BlueBlack:
        return 'assets/images/model3_blue_black_uv.png';
      case CarModel.model3BlueWhite:
        return 'assets/images/model3_blue_white_uv.png';
      case CarModel.model3GrayBlack:
        return 'assets/images/model3_gray_black_uv.png';
      case CarModel.model3GrayWhite:
        return 'assets/images/model3_gray_white_uv.png';
      case CarModel.model3RedBlack:
        return 'assets/images/model3_red_black_uv.png';
      case CarModel.model3RedWhite:
        return 'assets/images/model3_red_white_uv.png';
      case CarModel.model3WhiteBlack:
        return 'assets/images/model3_white_black_uv.png';
      case CarModel.model3WhiteWhite:
        return 'assets/images/model3_white_white_uv.png';
    }
  }
}
