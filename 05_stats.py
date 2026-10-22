from math import sqrt

groups = {
    "Supplements (54)": (16010, 50074),
    "Cosmetics, all": (20922, 52134),
    "Cosmetics, talc names out": (18482, 48380),
    "Cosmetics, talc + Exemption 4 out": (536, 10432),
}

for name, (severe, total) in groups.items():
    p = severe / total
    margin = 1.96 * sqrt(p * (1 - p) / total)
    print(f"{name}: {p*100:.1f}%  (95% CI {100*(p-margin):.1f}% to {100*(p+margin):.1f}%)")