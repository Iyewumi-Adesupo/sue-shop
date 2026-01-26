async function checkApiStatus() {
  const statusText = document.getElementById("status-text");

  try {
    const response = await fetch("/api/health", { timeout: 3000 });

    if (response.ok) {
      statusText.textContent = "All systems operational";
      statusText.className = "status ok";
    } else {
      throw new Error("API unhealthy");
    }
  } catch (error) {
    statusText.textContent =
      "Frontend online — backend temporarily unavailable";
    statusText.className = "status degraded";
  }
}

document.addEventListener("DOMContentLoaded", checkApiStatus);