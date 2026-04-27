const express = require('express');
const { exec } = require('child_process');

const app = express();
app.use(express.json());
app.use(express.static('public'));

app.post('/diagnose', (req, res) => {
    const symptoms = req.body.symptoms;

    if (!symptoms || symptoms.length === 0) {
        return res.json({ disease: "No symptoms selected" });
    }

    // Build Prolog facts safely
    let facts = symptoms
        .map(s => `assertz(symptom(${s}))`)
        .join(',');

    let command = `swipl -q -s prolog/medical.pl -g "clear,${facts},diagnose(D),write(D),halt."`;

    console.log("Running:", command); // DEBUG

    exec(command, (error, stdout, stderr) => {
        if (error) {
            console.error("Error:", error);
            return res.json({ disease: "Error running Prolog" });
        }

        console.log("STDOUT:", stdout); // DEBUG
        console.log("STDERR:", stderr); // DEBUG

        const result = stdout.trim();

        if (!result) {
            return res.json({ disease: "unknown" });
        }

        res.json({ disease: result });
    });
});
const PORT = 3000;


app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});