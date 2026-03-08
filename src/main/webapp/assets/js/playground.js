document.addEventListener("DOMContentLoaded", () => {
    const counterButton = document.getElementById("counter-button");
    const counterValue = document.getElementById("counter-value");
    const timeButton = document.getElementById("time-button");
    const timeOutput = document.getElementById("time-output");

    let count = 0;

    if (counterButton && counterValue) {
        counterButton.addEventListener("click", () => {
            count += 1;
            counterValue.textContent = String(count);
        });
    }

    if (timeButton && timeOutput) {
        timeButton.addEventListener("click", () => {
            const now = new Date();
            timeOutput.textContent = "当前时间：" + now.toLocaleString("zh-CN");
        });
    }
});
