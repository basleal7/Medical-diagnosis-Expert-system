const express = require('express');
const { exec } = require('child_process');

const app = express();

app.use(express.json());
app.use(express.static('public'));

app.post('/diagnose', (req, res) => {

    const symptoms = req.body.symptoms;

    // No symptoms selected
    if (!symptoms || symptoms.length === 0) {

        return res.json({
            disease: "No symptoms selected",
            treatment: "Please select symptoms.",
            precaution: "Select symptoms first."
        });
    }

    // Convert symptoms into Prolog facts
    const facts = symptoms
        .map(s => `assertz(symptom(${s}))`)
        .join(',');

    // Prolog command
    const command =
`swipl -q -s prolog/medical.pl -g "clear,${facts},diagnose(D),treatment(D,T),precaution(D,P),write(D),write('|'),write(T),write('|'),write(P),halt."`;

    console.log(command);

    exec(command, (error, stdout, stderr) => {

        console.log("STDOUT:", stdout);
        console.log("STDERR:", stderr);

        // PROLOG FAILED
        if (error) {

            return res.json({
                disease: "Error running Prolog",
                treatment: "Install SWI-Prolog and restart VS Code.",
                precaution: "Run: swipl --version in terminal."
            });
        }

        // Empty output
        if (!stdout || stdout.trim() === "") {

            return res.json({
                disease: "unknown",
                treatment: "No treatment found.",
                precaution: "No precaution found."
            });
        }

        // Split output safely
        const output = stdout.trim().split('|');

        res.json({
            disease: output[0] || "unknown",
            treatment: output[1] || "No treatment available",
            precaution: output[2] || "No precaution available"
        });

    });

});

// TEST ROUTE
app.get('/test-prolog', (req, res) => {

    exec("swipl --version", (error, stdout, stderr) => {

        if (error) {

            return res.send("SWI-Prolog NOT installed.");
        }

        res.send(stdout);
    });

});

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {

    console.log(`Server running on port http://localhost:${PORT}`);

});