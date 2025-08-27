import subprocess

def calculate_quantile(data, quantile):
    data_sorted = sorted(data)
    n = len(data_sorted)
    index = (n - 1) * quantile
    floor = int(index)
    ceil = floor + 1
    fraction = index - floor

    if ceil >= n:
        return data_sorted[floor]

    return data_sorted[floor] * (1 - fraction) + data_sorted[ceil] * fraction


# cmds
commands_no_coding_keys = [
    "./.build/arm64-apple-macosx/release/codable-benchmark-package-no-coding-keys --mode decode",
    "./.build/arm64-apple-macosx/release/codable-benchmark-package-no-coding-keys --mode decode_new",
    "./.build/arm64-apple-macosx/release/codable-benchmark-package-no-coding-keys --mode encode",
    "./.build/arm64-apple-macosx/release/codable-benchmark-package-no-coding-keys --mode encode_new"
]

commands_regular_coding_keys = [
    "./.build/arm64-apple-macosx/release/codable-benchmark-package --mode decode",
    "./.build/arm64-apple-macosx/release/codable-benchmark-package --mode decode_new",
    "./.build/arm64-apple-macosx/release/codable-benchmark-package --mode encode",
    "./.build/arm64-apple-macosx/release/codable-benchmark-package --mode encode_new"
]

def run(commands, prefix):
    results = {
        "decode": [],
        "decode_new": [],
        "encode": [],
        "encode_new": []
    }

    # Функция для извлечения числового значения из строки
    def extract_duration(output):
        try:
            return float(output.strip().split(":")[1])
        except:
            return None

    # Launch 100 time
    for _ in range(100):
        for cmd in commands:
            mode = cmd.split("--mode ")[1].strip()
            try:
                output = subprocess.check_output(cmd, shell=True, stderr=subprocess.STDOUT, text=True)
                duration = extract_duration(output)
                if duration is not None:
                    results[mode].append(duration)
            except Exception as e:
                print(f"Error executing command '{cmd}': {e}")

    # calculate quantile

    print("\nResults (in seconds):")
    for mode, durations in results.items():
        if durations:
            median = calculate_quantile(durations, 0.5)
            q25 = calculate_quantile(durations, 0.25)
            q75 = calculate_quantile(durations, 0.75)
            print(f"\nMode: {prefix} {mode}")
            print(f"  Median:     {median:.6f}")
            print(f"  0.25 Quantile: {q25:.6f}")
            print(f"  0.75 Quantile: {q75:.6f}")
        else:
            print(f"\nMode: {prefix} {mode} - no data collected")

run(commands_no_coding_keys, 'String as CodingKey')
run(commands_regular_coding_keys, 'Regular CodingKeys')