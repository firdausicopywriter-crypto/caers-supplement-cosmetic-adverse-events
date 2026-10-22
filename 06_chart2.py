from math import sqrt
import matplotlib.pyplot as plt

groups = {
    "Supplements (54)": (16010, 50074),
    "Cosmetics, all": (20922, 52134),
    "Cosmetics,\ntalc names out": (18482, 48380),
    "Cosmetics, talc +\nExemption 4 out": (536, 10432),
}

names, shares, errs = [], [], []
for name, (severe, total) in groups.items():
    p = severe / total
    names.append(name)
    shares.append(p * 100)
    errs.append(1.96 * sqrt(p * (1 - p) / total) * 100)

plt.figure(figsize=(10, 6))
plt.bar(names, shares, yerr=errs, capsize=6)
plt.ylabel("Reports with a severe outcome (%)")
plt.title("Severe share of reports (Death, Hospitalization or Life Threatening)")
plt.tight_layout()
plt.savefig("severe_share.png")
print("saved")