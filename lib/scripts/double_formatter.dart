num doubleWithoutDecimalToInt(double val) {
  return val % 1 == 0 ? val.toInt() : val;
}
