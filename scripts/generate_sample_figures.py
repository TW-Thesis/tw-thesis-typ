# /// script
# requires-python = ">=3.11"
# dependencies = ["matplotlib>=3.8", "numpy>=1.26", "scikit-learn>=1.4"]
# ///
"""Regenerate the original example figures with `uv run scripts/generate_sample_figures.py`.

The four regression plots use the same synthetic training observations. Each
curve is produced by a fitted estimator rather than drawn by hand. The other
figures illustrate the research workflow and two sampling distributions.
"""

from pathlib import Path

import matplotlib

matplotlib.use("Agg")

import matplotlib.pyplot as plt
import numpy as np
from matplotlib import font_manager
from matplotlib.patches import FancyArrowPatch, FancyBboxPatch
from sklearn.ensemble import RandomForestRegressor
from sklearn.linear_model import LinearRegression
from sklearn.neural_network import MLPRegressor
from sklearn.tree import DecisionTreeRegressor


ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "figures" / "samples"
CHINESE_FONT = font_manager.FontProperties(
    fname=ROOT / "fonts" / "chinese" / "edukai-5.1.ttf"
)
BLUE = "#315a9b"
AMBER = "#c47843"
INK = "#344054"


def finish(fig, path):
    fig.savefig(path, dpi=400, facecolor="white", edgecolor="none")
    plt.close(fig)


def plot_axes():
    fig, ax = plt.subplots(figsize=(2.45, 1.85))
    fig.subplots_adjust(left=0.18, right=0.96, top=0.94, bottom=0.22)
    ax.spines[["top", "right"]].set_visible(False)
    ax.spines[["left", "bottom"]].set_color("#7a8494")
    ax.tick_params(axis="both", colors=INK, labelsize=9, length=3, width=0.7)
    ax.set_xlim(-3.15, 3.15)
    ax.set_ylim(-1.9, 1.9)
    ax.set_xticks([-3, 0, 3])
    ax.set_yticks([-1, 0, 1])
    ax.set_xlabel("x", fontsize=10, color=INK, labelpad=0)
    ax.set_ylabel("y", fontsize=10, color=INK, rotation=0, labelpad=7)
    return fig, ax


def target(x):
    return 0.28 * x + 0.8 * np.sin(1.35 * x) + 0.18 * np.cos(2.3 * x)


def model_figures():
    rng = np.random.default_rng(2026)
    x = np.sort(rng.uniform(-3, 3, 46))
    y = target(x) + rng.normal(0, 0.16, len(x))
    x_grid = np.linspace(-3, 3, 600)
    estimators = {
        "a.png": LinearRegression(),
        "b.png": DecisionTreeRegressor(max_depth=4, min_samples_leaf=3, random_state=7),
        "c.png": RandomForestRegressor(
            n_estimators=120, max_depth=5, min_samples_leaf=2, random_state=7
        ),
        "d.png": MLPRegressor(
            hidden_layer_sizes=(32, 32), activation="tanh", solver="lbfgs",
            alpha=0.1, max_iter=2500, random_state=7,
        ),
    }
    for filename, estimator in estimators.items():
        estimator.fit(x[:, None], y)
        prediction = estimator.predict(x_grid[:, None])
        fig, ax = plot_axes()
        ax.scatter(x, y, s=12, color=AMBER, alpha=0.75, linewidths=0, zorder=2)
        ax.plot(x_grid, prediction, color=BLUE, linewidth=2.1, zorder=3)
        finish(fig, OUTPUT / filename)


def sampling_figures():
    x_grid = np.linspace(-3, 3, 600)
    uniform = np.linspace(-2.9, 2.9, 21)
    # Inverse-CDF sampling puts more points where the example curve is steep.
    weights = 0.12 + np.abs(np.gradient(target(x_grid), x_grid))
    cdf = np.cumsum(weights)
    cdf = (cdf - cdf[0]) / (cdf[-1] - cdf[0])
    importance = np.interp(np.linspace(0.02, 0.98, 21), cdf, x_grid)
    for filename, samples in (
        ("sampling-uniform.png", uniform),
        ("sampling-importance.png", importance),
    ):
        fig, ax = plot_axes()
        ax.plot(x_grid, target(x_grid), color="#8394ac", linewidth=1.4)
        ax.scatter(samples, target(samples), s=18, color=AMBER, zorder=3)
        finish(fig, OUTPUT / filename)


def architecture_figure():
    fig, ax = plt.subplots(figsize=(5.4, 1.65))
    fig.subplots_adjust(left=0.015, right=0.985, top=0.95, bottom=0.05)
    ax.set_xlim(0, 10)
    ax.set_ylim(0, 2)
    ax.axis("off")
    labels = ("資料蒐集", "資料處理", "模型訓練", "模型評估", "結果分析")
    for i, label in enumerate(labels):
        x = i * 2.03
        box = FancyBboxPatch(
            (x, 0.63), 1.72, 0.74,
            boxstyle="round,pad=0.08,rounding_size=0.08",
            facecolor="#eaf1fa", edgecolor="#7d9bc1", linewidth=1,
        )
        ax.add_patch(box)
        ax.text(
            x + 0.86, 1.0, label, ha="center", va="center",
            fontproperties=CHINESE_FONT, fontsize=12, color=INK,
        )
        if i < len(labels) - 1:
            ax.add_patch(FancyArrowPatch(
                (x + 1.82, 1.0), (x + 2.00, 1.0),
                arrowstyle="-|>", mutation_scale=11, color=BLUE, linewidth=1.2,
            ))
    finish(fig, OUTPUT / "architecture.png")


def main():
    OUTPUT.mkdir(parents=True, exist_ok=True)
    model_figures()
    sampling_figures()
    architecture_figure()


if __name__ == "__main__":
    main()
