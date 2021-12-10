fn part_one(lines: &Vec<String>) -> i32 {
    lines
        .into_iter()
        .filter(|line| {
            line.contains("]") || line.contains("}") || line.contains(")") || line.contains(">")
        })
        .map(|line| {
            let spl: Vec<_> = line.trim().split("").collect();

            let mut total_score = 0;

            for i in 0..spl.len() {
                let score = match spl[i] {
                    "]" | ")" | ">" | "}" => match spl[i - 1] {
                        "(" | "[" | "{" | "<" => match spl[i] {
                            ")" => 3,
                            "]" => 57,
                            "}" => 1197,
                            ">" => 25137,
                            _ => -1,
                        },
                        _ => -1,
                    },
                    _ => -1,
                };

                if score != -1 {
                    total_score = score;
                    break;
                }
            }

            total_score
        })
        .reduce(|c, acc| c + acc)
        .unwrap_or(-1)
}

fn part_two(lines: &Vec<String>) -> i64 {
    let mut incomplete_scores: Vec<_> = lines
        .into_iter()
        .filter(|line| {
            !line.contains("]") && !line.contains("}") && !line.contains(")") && !line.contains(">")
        })
        .map(|line| {
            let spl: Vec<_> = line.trim().split("").collect();

            let mut complete = Vec::new();

            for i in (0..spl.len()).rev() {
                let complete_char = match spl[i] {
                    "(" => ")",
                    "{" => "}",
                    "[" => "]",
                    "<" => ">",
                    _ => "",
                };

                if !complete_char.is_empty() {
                    complete.push(complete_char);
                }
            }

            complete.into_iter().fold(0, |total, d| {
                let score_digit = match d {
                    ")" => 1,
                    "]" => 2,
                    "}" => 3,
                    ">" => 4,
                    _ => 0,
                };

                total * 5 + score_digit
            })
        })
        .collect();

    incomplete_scores.sort();

    incomplete_scores[incomplete_scores.len()/2]
}

fn main() {
    let content = include_str!("input.txt");

    let lines: Vec<_> = content
        .split("\n")
        .into_iter()
        .filter(|line| (*line).ne(""))
        .map(|line| {
            let mut prev = line.to_string();
            let mut new = prev.clone();

            loop {
                prev = new.clone();
                new = prev
                    .replace("[]", "")
                    .replace("{}", "")
                    .replace("()", "")
                    .replace("<>", "");

                if prev == new {
                    break;
                }
            }

            new
        })
        .collect();

    println!("Part 1: {}", part_one(&lines));
    println!("Part 2: {}", part_two(&lines));
}
