double? mileToKM(double? miles) {
  if (miles != null) {
    return (miles * 1.609).roundToDouble();
  } else {
    return 0;
  }
}
