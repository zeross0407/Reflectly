enum Flavor {
  dev,
  production,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'Reflectly Dev';
      case Flavor.production:
        return 'Reflectly';
      default:
        return 'title';
    }
  }

}
