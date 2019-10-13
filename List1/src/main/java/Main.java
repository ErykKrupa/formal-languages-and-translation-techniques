import org.apache.commons.cli.*;

import java.util.*;

public class Main {
    private static Option algorithm = Option.builder("a").longOpt("algorithm").required().hasArg()
            .desc("pattern searching algorithm: fsm- finite state machine, kmp- knuth-morris-pratt").build();
    private static Option text = new Option("t", "text", true, "text for search in");
    private static Option pattern = new Option("p", "pattern", true,
            "pattern to be searched");
    private static Option help = new Option("h", "help", false, "print this help");
    private static Options options = new Options();
    private static CommandLineParser parser = new DefaultParser();

    static {
        options.addOption(algorithm);
        options.addOption(text);
        options.addOption(pattern);
        options.addOption(help);
    }

    private static void checkForHelp(String[] args) throws ParseException {
        Options optionsForHelp = new Options();
        optionsForHelp.addOption(help);
        CommandLine cmd = parser.parse(optionsForHelp, args, true);
        if (cmd.hasOption(help.getOpt())) {
            new HelpFormatter().printHelp("help", options);
            System.exit(0);
        }
    }

    public static void main(String[] args) throws ParseException {
        checkForHelp(args);
        CommandLine cmd = parser.parse(options, args, false);
        String algorithm = cmd.getOptionValue("algorithm");
        if (!algorithm.equals("fsm") && !algorithm.equals("kmp")) {
            System.err.println("Incorrect algorithm");
            System.exit(1);
        }
        Scanner scanner = new Scanner(System.in);
        String text, pattern;
        System.out.print("Text: ");
        if (cmd.hasOption("text")) {
            text = cmd.getOptionValue("text");
            System.out.println(text);
        } else {
            text = scanner.nextLine();
        }
        System.out.print("Pattern: ");
        if (cmd.hasOption("pattern")) {
            pattern = cmd.getOptionValue("pattern");
            System.out.println(pattern);
        } else {
            pattern = scanner.nextLine();
        }
        switch (algorithm) {
            case "fsm":
                for (int result : FiniteStateMachine.search(text, pattern)) {
                    System.out.print(result + " ");
                }
                break;
            case "kmp":
                for (int result : KnuthMorrisPratt.search(text, pattern)) {
                    System.out.print(result + " ");
                }
                break;
        }
    }
}
