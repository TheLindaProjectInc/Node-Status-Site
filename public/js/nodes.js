
setTimeout(ajax_load_block(), 100);
setInterval(ajax_load_block, 38800);
setTimeout(ajax_load_conns(), 500);
setInterval(ajax_load_conns, 64200);
setTimeout(ajax_load_status(), 700);
setInterval(ajax_load_status, 87400);
setTimeout(ajax_load_vers(), 400);

function ajax_load_block() {
  element = "";
  path = "/api/getbestblock";
  document.getElementById("blockhash").classList.add("coloryellow");
  document.getElementById("blockcount").classList.add("coloryellow");
  document.getElementById("blockcount").innerHTML = "0000000";
  var xhr = new XMLHttpRequest();
  xhr.open('GET', path, true);
  xhr.ontimeout = function () {
    document.getElementById("blockhash").classList.remove("coloryellow");
    document.getElementById("blockhash").classList.add("colorred");
    document.getElementById("blockcount").classList.remove("coloryellow");
    document.getElementById("blockcount").classList.add("colorred");
    return console.error("Request Get Best Block - Request timed out.");
  };
  xhr.addEventListener("error", function (event) {
    document.getElementById("blockhash").classList.remove("coloryellow");
    document.getElementById("blockhash").classList.add("colorred");
    document.getElementById("blockcount").classList.remove("coloryellow");
    document.getElementById("blockcount").classList.add("colorred");
    console.error(event);
  });
  xhr.addEventListener("load", function (event) {
    if (xhr.status != 200) {
      document.getElementById("blockhash").classList.remove("coloryellow");
      document.getElementById("blockhash").classList.add("colorred");
      document.getElementById("blockcount").classList.remove("coloryellow");
      document.getElementById("blockcount").classList.add("colorred");
      document.getElementById("blockcount").innerHTML = "ERROR!!";
    } else {
      json = JSON.parse(this.responseText);
      document.getElementById("blockhash").innerHTML = json.blockhash;
      document.getElementById("blockcount").innerHTML = json.height;
      setTimeout(function() {
        document.getElementById("blockhash").classList.remove("coloryellow");
        document.getElementById("blockhash").classList.remove("colorred");
        document.getElementById("blockcount").classList.remove("coloryellow");
        document.getElementById("blockcount").classList.remove("colorred");
      }, 400);
    }
  });
  xhr.timeout = 9000;
  xhr.send();
}

function ajax_load_conns() {
  element = "";
  path = "/api/getconnectioncount";
  document.getElementById("networkconn").classList.add("coloryellow");
  document.getElementById("networkconn").innerHTML = "00";
  var xhr = new XMLHttpRequest();
  xhr.open('GET', path, true);
  xhr.ontimeout = function () {
    document.getElementById("networkconn").classList.remove("coloryellow");
    document.getElementById("networkconn").classList.add("colorred");
    return console.error("Request Get Connections - Request timed out.");
  };
  xhr.addEventListener("error", function (event) {
    document.getElementById("networkconn").classList.remove("coloryellow");
    document.getElementById("networkconn").classList.add("colorred");
    console.error(event);
  });
  xhr.addEventListener("load", function (event) {
    if (xhr.status != 200) {
      document.getElementById("networkconn").classList.remove("coloryellow");
      document.getElementById("networkconn").classList.add("colorred");
      document.getElementById("networkconn").innerHTML = "NA";
    } else {
      json = JSON.parse(this.responseText);
      document.getElementById("networkconn").innerHTML = json.connections;
      setTimeout(function() {
        document.getElementById("networkconn").classList.remove("coloryellow");
        document.getElementById("networkconn").classList.remove("colorred");
      }, 400);
    }
  });
  xhr.timeout = 9000;
  xhr.send();
}

function ajax_load_vers() {
  element = "";
  path = "/api/getnetworkinfo";
  document.getElementById("nodeversion").classList.add("coloryellow");
  document.getElementById("nodeversion").innerHTML = "0001";
  document.getElementById("nodeprotocol").classList.add("coloryellow");
  document.getElementById("nodeprotocol").innerHTML = "001";
  var xhr = new XMLHttpRequest();
  xhr.open('GET', path, true);
  xhr.ontimeout = function () {
    document.getElementById("nodeversion").classList.remove("coloryellow");
    document.getElementById("nodeversion").classList.add("colorred");
    document.getElementById("nodeprotocol").classList.remove("coloryellow");
    document.getElementById("nodeprotocol").classList.add("colorred");
    return console.error("Request Get Version - Request timed out.");
  };
  xhr.addEventListener("error", function (event) {
    document.getElementById("nodeversion").classList.remove("coloryellow");
    document.getElementById("nodeversion").classList.add("colorred");
    document.getElementById("nodeprotocol").classList.remove("coloryellow");
    document.getElementById("nodeprotocol").classList.add("colorred");
    console.error(event);
  });
  xhr.addEventListener("load", function (event) {
    if (xhr.status != 200) {
      document.getElementById("nodeversion").classList.remove("coloryellow");
      document.getElementById("nodeversion").classList.add("colorred");
      document.getElementById("nodeversion").innerHTML = "NA";
      document.getElementById("nodeprotocol").classList.remove("coloryellow");
      document.getElementById("nodeprotocol").classList.add("colorred");
      document.getElementById("nodeprotocol").innerHTML = "NA";
    } else {
      json = JSON.parse(this.responseText);
      document.getElementById("nodeversion").innerHTML = json.networkinfo.version;
      document.getElementById("nodeprotocol").innerHTML = json.networkinfo.protocol;
      setTimeout(function() {
        document.getElementById("nodeversion").classList.remove("coloryellow");
        document.getElementById("nodeversion").classList.remove("colorred");
        document.getElementById("nodeprotocol").classList.remove("coloryellow");
        document.getElementById("nodeprotocol").classList.remove("colorred");
      }, 400);
    }
  });
  xhr.timeout = 9000;
  xhr.send();
}

function ajax_load_status() {
  element = "";
  path = "/api/getchainstatus";
  //path = "/api/getchaininfo"; // shows raw info
  document.getElementById("nodestatus").classList.add("coloryellow");
  document.getElementById("nodestatus").innerHTML = "Loading";
  var xhr = new XMLHttpRequest();
  xhr.open('GET', path, true);
  xhr.ontimeout = function () {
    document.getElementById("nodestatus").classList.remove("coloryellow");
    document.getElementById("nodestatus").classList.add("colorred");
    return console.error("Request Get Connections - Request timed out.");
  };
  xhr.addEventListener("error", function (event) {
    document.getElementById("nodestatus").classList.remove("coloryellow");
    document.getElementById("nodestatus").classList.add("colorred");
    console.error(event);
  });
  xhr.addEventListener("load", function (event) {
    if (xhr.status != 200) {
      document.getElementById("nodestatus").classList.remove("coloryellow");
      document.getElementById("nodestatus").classList.add("colorred");
      document.getElementById("nodestatus").innerHTML = "NA";
    } else {
      json = JSON.parse(this.responseText);
      var forked = json.chainstatus.forkSuspected;
      document.getElementById("nodestatus").innerHTML = forked ? 'Fork?' : 'Nominal';
      setTimeout(function() {
        if (forked) {
          document.getElementById("nodestatus").classList.remove("coloryellow");
          document.getElementById("nodestatus").classList.add("colorred");
        } else {
          document.getElementById("nodestatus").classList.remove("coloryellow");
          document.getElementById("nodestatus").classList.remove("colorred");
        }
    }, 500);
    }
  });
  xhr.timeout = 9000;
  xhr.send();
}
