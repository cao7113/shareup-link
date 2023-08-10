const tabs = await chrome.tabs.query({
  url: [
    "http://*/*",
    "https://*/*"
  ]
});

const template = document.getElementById('li_template');
const elements = new Set();
const urls = [];

for (const tab of tabs) {
  const element = template.content.firstElementChild.cloneNode(true);

  const title = tab.title;
  const url = tab.url;

  element.querySelector('.title').textContent = title;
  element.querySelector('.url').textContent = url;
  element.querySelector('a').addEventListener('click', async () => {
    // need to focus window as well as the active tab
    await chrome.tabs.update(tab.id, { active: true });
    await chrome.windows.update(tab.windowId, { focused: true });
  });

  elements.add(element);
  urls.push({"title": title, "url": url});
}
document.querySelector('ul').append(...elements);
document.querySelector("#tabsInfo").textContent = `${tabs.length} tabs`;

// send remote request
// const url = "http://localhost:4000/api/links"
const url = "https://slink.fly.dev/api/links"
document.querySelector('#submitRemote').addEventListener('click', async () => {
  fetch(url,
    {
      method: "POST",
      body: JSON.stringify({"links": urls}),
      headers: {
        "Content-Type": "application/json"
      }
    })
    .then(response => {
      // indicates whether the response is successful (status code 200-299) or not
      if (!response.ok) {
        throw new Error(`Request failed with status ${reponse.status}`);
      }
      return response.json();
    })
    .then(data => {
      document.querySelector("#respInfo").textContent = JSON.stringify(data); 
    })
    .catch(error => console.log(error));
});

