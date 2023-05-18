const TuyAPI = require('tuyapi');
const axios = require('axios');
let readings = {}
const device = new TuyAPI({
    id: 'bfce8f4894d05bca6em6ub',
    key: '>uZA1Ro1}sC8AQ8w'
});

function runCode() {
    // Find device on network
    device.find().then(() => {
        // Connect to device
        device.connect();
    });

    // Add event listeners
    device.on('connected', () => {
        console.log('Connected to device!');
    });

    device.on('disconnected', () => {
        console.log('Disconnected from device.');
    });

    device.on('error', error => {
        console.log('Error!', error);
    });


    device.on('data', data => {
        const temp = data.dps['8'] / 10;
        const orp = data.dps['131'];
        const salt = data.dps['126'] / 1000;
        const ph = data.dps['106'] / 100

        readings = {
            "deviceId": 19,
            "sensorData": [
                {
                    "reading": ph,
                    "parameter": "pH",
                    "unitId": 25
                },
                {
                    "reading": orp,
                    "parameter": "Oxidation-reduction potential (ORP)",
                    "unitId": 46
                },
                {
                    "reading": temp,
                    "parameter": "Water Temperature",
                    "unitId": 44
                },
                {
                    "reading": salt,
                    "parameter": "Salinity",
                    "unitId": 50
                }
            ]
        }
    });
    console.log(readings)
    // Disconnect after 10 seconds
    setTimeout(() => {
        device.disconnect();
    }, 10000);
}

// Run the code immediately
runCode();
const makePostRequest = async () => {
    try {
        const response = await axios.post('http://localhost:8080/api/reading', { readings });
        console.log('Response:', response.data);
    } catch (error) {
        console.error('Error:', error.message);
    }
};

// Function to make the POST request every 30 seconds
const postEvery30Seconds = () => {
    setInterval(makePostRequest, 30000);
};

// Start making the POST requests
postEvery30Seconds();

// Run the code every 5 seconds
setInterval(() => {
    runCode();
}, 3000);