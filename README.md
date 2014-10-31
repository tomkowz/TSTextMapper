TSTextMapper
===

Few classes allow you to map a text inside `UILabel` and make the text inside tappable, means it adds the ability to detect which word is tapped. It’s both very simple and powerful.

Demo movie `tstextmapper.mov` is attached in the repo and available on [youtube](http://youtu.be/2FRJvEACS6w).

### How-To

1. Create `TSTextMapper`.
2. Select one of the few methods how text mapper should work `mapTextAndMakeAllTappable` or `mapTextWithTappableRanges`
3. Call `textForPoint` method when you want to get a word.


---

- `mapTextAndMakeAllTappable` method makes all text tappable.

- `mapTextWithTappableRanges` method makes tappable text only in passed ranges.

- `textForPoint` method returns `TSTextProxy`. It contains property `value`.

### Debug

If you noticed that something may be wrong with detecting touches (word is not selected or not this word is selected) you can check few things:

- In `TSTextMapper` is `debug` method and it's commented inside `map` method. Put a breakpoint on line `debugView.snapshot()` in `debug` method. Method is called for the first time when `UILabel` is touched.
- In `TSTextAnalizer` is `debug` method and it's commented inside `mapLines` method. Uncomment it. It's called when `UILabel` is touched for the first time. Entire text should be printed out and the text should be presented in lines the same like it looks inside `UILabel`.
- In `TSTextRefDetector` there is `debug` method which is commented in `textRefs` method. Uncomment it. All words and whitespaces should be printed out.
