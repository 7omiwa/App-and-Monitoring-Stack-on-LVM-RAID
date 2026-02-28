document.addEventListener("DOMContentLoaded", loadData);

document.getElementById("dataForm").addEventListener("submit", async (e) => {
    e.preventDefault();

    const text = document.getElementById("userText").value;

    const response = await fetch("/submit", {
        method: "POST",
        body: new URLSearchParams({ user_text: text })
    });

    document.getElementById("userText").value = "";

    loadData();
});

async function loadData() {
    const res = await fetch("/data");
    const items = await res.json();

    const list = document.getElementById("dataList");
    list.innerHTML = "";

    items.forEach(t => {
        const li = document.createElement("li");
        li.textContent = t;
        list.appendChild(li);
    });
}
