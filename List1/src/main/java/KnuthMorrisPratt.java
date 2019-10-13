import java.util.LinkedList;
import java.util.List;

class KnuthMorrisPratt {
    static List<Integer> search(String text, String pattern) {
        return search(text.toCharArray(), pattern.toCharArray());
    }

    static List<Integer> search(char[] text, char[] pattern) {
        List<Integer> results = new LinkedList<>();
        int textLength = text.length;
        int patternLength = pattern.length;
        if (patternLength == 0) {
            for (int i = 1; i <= textLength + 1; i++) {
                results.add(i);
            }
            return results;
        }
        int[] prefix = computePrefix(pattern);
        int matched = 0;
        for (int letterPosition = 0; letterPosition < textLength; letterPosition++) {
            while (matched > 0 && pattern[matched] != text[letterPosition]) {
                matched = prefix[matched - 1];
            }
            if (pattern[matched] == text[letterPosition]) {
                matched++;
            }
            if (matched == patternLength) {
                results.add(letterPosition + 2 - patternLength);
                matched = prefix[matched - 1];
            }
        }
        return results;
    }

    private static int[] computePrefix(char[] pattern) {
        int patternLength = pattern.length;
        int[] prefix = new int[patternLength];
        prefix[0] = 0;
        int matched = 0;
        for (int letterPosition = 1; letterPosition < patternLength; letterPosition++) {
            while (matched > 0 && pattern[matched] != pattern[letterPosition]) {
                matched = prefix[matched - 1];
            }
            if (pattern[matched] == pattern[letterPosition]) {
                matched++;
            }
            prefix[letterPosition] = matched;
        }
        return prefix;
    }
}
