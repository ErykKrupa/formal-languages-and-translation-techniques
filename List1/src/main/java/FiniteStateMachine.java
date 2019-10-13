import java.util.*;

class FiniteStateMachine {
    static List<Integer> search(String text, String pattern) {
        return search(text.toCharArray(), pattern.toCharArray());
    }

    static List<Integer> search(char[] text, char[] pattern) {
        Map<Integer, Map<Character, Integer>> transitions = computeTransition(pattern);
        List<Integer> results = new LinkedList<>();
        int patternLength = pattern.length;


        int state = 0;
        if (0 == patternLength) {
            results.add(1);
        }
        for (int letterPosition = 0; letterPosition < text.length; letterPosition++) {
            state = transitions.get(state).get(text[letterPosition]);
            if (state == patternLength) {
                results.add(letterPosition + 2 - patternLength);
            }
        }
        return results;
    }

    private static Map<Integer, Map<Character, Integer>> computeTransition(char[] pattern) {
        int patternLength = pattern.length;
        Map<Integer, Map<Character, Integer>> transitions = new HashMap<>();
        for (int i = 0; i <= patternLength; i++) {
            transitions.put(i, new HashMap<>());
        }
        for (int state = 0; state <= patternLength; state++) {
            for (char letter : getAlphabet()) {
                int target = Math.min(patternLength, state + 1) + 1;
                do {
                    target--;
                } while (!checkSuffix(pattern, target, state, letter));
                transitions.get(state).put(letter, target);
            }
        }
        return transitions;
    }

    private static boolean checkSuffix(char[] pattern, int target, int state, char letter) {
        if (target == 0) {
            return true;
        }
        if (pattern[target - 1] == letter) {
            for (int i = 1; i < target; i++) {
                if (pattern[target - i - 1] != pattern[state - i]) {
                    return false;
                }
            }
            return true;
        }
        return false;
    }

    private static List<Character> getAlphabet() {
        List<Character> alphabet = new LinkedList<>();
        Character.UnicodeBlock basicLatin = Character.UnicodeBlock.BASIC_LATIN;
        Character.UnicodeBlock latinExtended = Character.UnicodeBlock.LATIN_EXTENDED_A;
        for (int codePoint = Character.MIN_CODE_POINT; codePoint <= Character.MAX_CODE_POINT; codePoint++) {
            if (Character.UnicodeBlock.of(codePoint) == basicLatin ||
                    Character.UnicodeBlock.of(codePoint) == latinExtended) {
                alphabet.add((char) codePoint);
            }
        }
        return alphabet;
    }
}
