Customizable Questionnaire for Flutter.

This package allows to create questionnaire (similar to poll but with a right option)
that are customizable.

The idea of this package was based in [Flutter Polls](https://pub.dev/packages/flutter_polls)

## Features

#### Animated

![animated](https://github.com/Ch4rl3B/inquiry/blob/main/media/device-2023-03-02-014945.gif)

#### How do it look

![img1](https://github.com/Ch4rl3B/inquiry/blob/main/media/Screenshot_20230302_015107.png)
![img2](https://github.com/Ch4rl3B/inquiry/blob/main/media/Screenshot_20230302_015125.png)

## Getting started

In the `pubspec.yaml` of your flutter project, add the following dependency:

```yaml
dependencies:
  ...
  inquiry: latest_version
```

Import it:

```dart
import 'package:inquiry/inquiry.dart';
```

## Usage

You can create a simple inquiry with

```dart

Inquiry(
  inquiryId: 'inquiry',
  options: List.generate(
    5, (index) {
      return InquiryOption(
        id: index,
        title: Text(
          'Option $index',
        ),
        votes: 0,
        rightAnswer: index == 2,
      );
    },
  ),
  titleWidget: Text(
    "Title of the Inquiry",
    style: const TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 16,
    ),
  ),
  onVoted: (option, amount) {
    print("Voted option: ${option.title}. "
        "The option is ${option.rightAnswer ? 'correct' : 'incorrect'}");
    return Future.value(true);
  },
);
```

You can customize the look and feel with `InquiryStyle`

```dart
  InquiryStyle(
    optionsBorderRadius: BorderRadius.circular(8),
    votedInquiryPercentRadius: const Radius.circular(8),
    optionsBorder: Border.all(color: Colors.black),
    rightAnswerBorder: Border.all(color: Colors.green),
    optionsBackgroundColor: Colors.grey.shade300,
    wrongBackgroundColor: Colors.red.shade100,
    rightBackgroundColor: Colors.green.shade100,
    optionsSplashColor: Colors.blue,
    votedWrongProgressColor: Colors.red.shade300,
    votedRightProgressColor: Colors.green.shade300,
    voteInProgressColor: Colors.blue,
    voteButtonStyle: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      padding:
      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    ),
    crossAxisAlignment: CrossAxisAlignment.start,
  )
```

for more information look at the [example](https://github.com/Ch4rl3B/inquiry/blob/main/example/lib/main.dart)

## Additional information

You can contribute to the package any time, just create a Pull Request.
All contributions are welcome 👍🏼