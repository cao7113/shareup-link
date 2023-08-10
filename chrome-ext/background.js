// chrome.action.onClicked.addListener((tab) => {
//   chrome.scripting.executeScript({
//     target: {tabId: tab.id},
//     func: contentScriptFunc,
//     args: ['action'],
//   });
// });

// function contentScriptFunc(name) {
//   alert(`"${name}" executed`);
// }

// put in base settings todo
// const url = "http://localhost:4000/api/links"
const url = "https://slink.fly.dev/api/links"

// This callback WILL NOT be called for "_execute_action"
chrome.commands.onCommand.addListener((command, tab) => {
  console.log(`Command "${command}" called and tab: "${tab.url}"`);

  if (command === 'collect') {
    console.log(`creating link from url: "${tab.url}"`);
    const link_obj = {
      "title": tab.title,
      "url": tab.url
    }
    fetch(url,
      {
        method: "POST",
        body: JSON.stringify({"link": link_obj}),
        headers: {
          "Content-Type": "application/json"
        }
      })
      .then(response => {
        // indicates whether the response is successful (status code 200-299) or not
        // if (!response.ok) {
        //   throw new Error(`Request failed with status ${reponse.status}`);
        // }
        return response.json();
      })
      .then(data => {
        console.log(`"${tab.url}" added with response: ${JSON.stringify(data)}`);
        chrome.scripting.executeScript({
          target: {tabId: tab.id},
          func: alertLinkAdded,
          args: [command, tab.url],
        });
      })
      .catch(error => {
        console.log(error)
      });
  }
});

function alertLinkAdded(name, url) {
  alert(`"${url}" collected by ${name} command!`);
}

chrome.runtime.onInstalled.addListener((reason) => {
  if (reason === chrome.runtime.OnInstalledReason.INSTALL) {
    checkCommandShortcuts();
  }
});

// Only use this function during the initial install phase. After
// installation the user may have intentionally unassigned commands.
function checkCommandShortcuts() {
  console.log("check extension commands");
  chrome.commands.getAll((commands) => {
    let missingShortcuts = [];

    for (let {name, shortcut} of commands) {
      if (shortcut === '') {
        missingShortcuts.push(name);
      }
    }

    if (missingShortcuts.length > 0) {
      // Update the extension UI to inform the user that one or more
      // commands are currently unassigned.
      console.log(`command "${missingShortcuts}" missing shortcuts!`);
    }
  });
}