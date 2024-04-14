const express = require('express');
const sql = require('mssql/msnodesqlv8');
const bodyParser = require('body-parser');
const cors = require('cors')
const mysql = require('mysql');
const fs = require('fs');
const multer = require('multer');
const moment = require('moment-timezone');


const uploadDirectory = 'uploads/';
const app = express();
const port = 3000;

app.use(cors())
app.use(bodyParser.json());

const dbConfig = {
  server: 'LAPTOP-UFH9Q8I3\\SQLEXPRESS',
  database: 'project',
  driver: 'msnodesqlv8',
  options: {
    trustedConnection: true,
    requestTimeout: 300000 // 5 minutes (adjust as needed)

  }
};

app.post('/api/signup', (req, res) => {
  const { f_name, dob, gender, email, u_name, password } = req.body;

  sql.connect(dbConfig, function(err) {
    if (err) {
      console.log(err);
      return res.status(500).json({ error: 'Internal Server Error' });
    }

    var request = new sql.Request();
    request.query(`INSERT INTO candidate (f_name, dob, gender, email, u_name, password) 
                   VALUES ('${f_name}', '${dob}', '${gender}', '${email}', '${u_name}', '${password}')`,
                   function(err, result) {
      if (err) {
        console.log(err);
        return res.status(500).json({ error: 'Internal Server Error' });
      }
      
      console.log('Data inserted successfully:', result);
      res.status(200).json({ message: 'Data inserted successfully!' });
    });
  });
});







app.post('/api/login', (req, res) => {
  const { username, password } = req.body;

  const loginQuery = `SELECT * FROM candidate WHERE u_name = '${username}' AND password = '${password}'`;
  
  sql.connect(dbConfig, function(err) {
    if (err) {
      console.log(err);
      return res.status(500).json({ error: 'Internal Server Error' });
    }

    const request = new sql.Request();
    
    request.query(loginQuery, function(err, result) {
      if (err) {
        console.log(err);
        return res.status(500).json({ error: 'Internal Server Error' });
      }

      if (result.recordset.length === 0) {
        return res.status(401).json({ error: 'Invalid username or password' });
      }

      // If login is successful, redirect user to appropriate page
      if (result.recordset[0].isAdmin) {
        // Redirect to admin dashboard if user is an admin
        return res.status(200).json({ redirectTo: '/admin/dashboard' });
      } else {
        // Redirect to user dashboard if user is not an admin
        return res.status(200).json({ redirectTo: '/user/dashboard' });
      }
    });
  });
});



app.post('/api/logins', async (req, res) => {
  const { username, password } = req.body;

  try {
    await sql.connect(dbConfig);
    const result = await sql.query`SELECT * FROM users WHERE username = ${username} AND password = ${password}`;
    if (result.recordset.length > 0) {
      res.status(200).json({ userType: result.recordset[0].category });
    } else {
      const employeeResult = await sql.query`SELECT * FROM employee WHERE username = ${username} AND password = ${password}`;
      if (employeeResult.recordset.length > 0) {
        res.status(200).json({ userType: 'Employee' });
      } else {
        res.status(401).json({ error: 'Invalid username or password' });
      }
    }
  } catch (err) {
    console.error('Error executing query: ' + err.stack);
    res.status(500).json({ error: 'Internal server error' });
  } finally {
    sql.close();
  }
});


app.get('/api/employee/:username', async (req, res) => {
  const username = req.params.username;

  try {
    await sql.connect(dbConfig);
    const result = await sql.query`SELECT * FROM employee WHERE username = ${username}`;
    if (result.recordset.length > 0) {
      res.status(200).json(result.recordset[0]);
    } else {
      res.status(404).json({ error: 'Employee not found' });
    }
  } catch (err) {
    console.error('Error executing query: ' + err.stack);
    res.status(500).json({ error: 'Internal server error' });
  } finally {
    sql.close();
  }
});



app.get('/api/candret', async (req, res) => {
    console.log('Received GET request at /api/candret');

    try {
        // Connect to SQL Server Database
        await sql.connect(dbConfig);
        console.log('Connected to SQL Server Database');

        // Execute the query to retrieve all department details
        const result = await sql.query`
            (SELECT * FROM candidate where u_name=@u_name)
        `;

        if (result.recordset.length > 0) {
            // Send department details as JSON response
            res.status(200).json(result.recordset);
        } else {
            res.status(404).json({ error: 'No department found' });
        }
    } catch (error) {
        console.error('Error:', error);

        // Send an error response
        res.status(500).json({ error: 'Internal Server Error' });
    } finally {
        // Close the connection
        await sql.close();
        console.log('Connection closed successfully');
    }
});





app.post('/api/adddep', (req, res) => {
  const { DEPT_NAME, DEPT_SHORT_NAME } = req.body;

  sql.connect(dbConfig, function(err) {
    if (err) {
      console.log(err);
      return res.status(500).json({ error: 'Internal Server Error' });
    }

    var request = new sql.Request();
    request.query(`INSERT INTO department (DEPT_NAME, DEPT_SHORT_NAME) 
                   VALUES ('${DEPT_NAME}', '${DEPT_SHORT_NAME}')`,
                   function(err, result) {
      if (err) {
        console.log(err);
        return res.status(500).json({ error: 'Internal Server Error' });
      }
      
      console.log('Data inserted successfully:', result);
      res.status(200).json({ message: 'Data inserted successfully!' });
    });
  });
});


app.get('/api/managedept', async (req, res) => {
  console.log('Received GET request at /api/managedept');

  try {
      // Connect to SQL Server Database
      const pool = await sql.connect(dbConfig);
      console.log('Connected to SQL Server Database');

      // Execute the query to retrieve all department details
      const result = await pool.request()
          .query('SELECT * FROM department');

      // Release the connection
      sql.close();
      console.log('Connection closed successfully');

      if (result.recordset.length > 0) {
          // Send department details as JSON response
          res.status(200).json(result.recordset);
      } else {
          res.status(404).json({ error: 'No departments found' });
      }
  } catch (error) {
      console.error('Error:', error);

      // Send an error response
      res.status(500).json({ error: 'Internal Server Error' });
  }
});


app.post('/api/req', async (req, res) => {
  const { reqid, name, DEPT_ID } = req.body;
  try {
    // Connect to the database
    await sql.connect(dbConfig);
    // Insert requirement into requirements table
    await sql.query`INSERT INTO req (reqid, name, DEPT_ID) VALUES (${reqid}, ${name}, ${DEPT_ID})`;
    // Send success response
    res.status(201).json({ message: 'Requirement inserted successfully' });
  } catch (err) {
    console.error('Error inserting requirement:', err);
    res.status(500).json({ error: 'Internal Server Error' });
  } finally {
    // Close the connection
    await sql.close();
  }
});


app.post('/api/addemp', (req, res) => {
  const { first_name, middle_name, last_name, age, gender, email, phno, username, password,DEPT_ID, DESIGN_ID } = req.body;

  sql.connect(dbConfig, function(err) {
    if (err) {
      console.log(err);
      return res.status(500).json({ error: 'Internal Server Error' });
    }

    var request = new sql.Request();
    request.query(`INSERT INTO employee ( first_name, middle_name, last_name, age, gender, email, phno, username, password,DEPT_ID, DESIGN_ID) 
                   VALUES ('${first_name}', '${middle_name}','${last_name}',${age},'${gender}','${email}',${phno},'${username}','${password}',${DEPT_ID},${DESIGN_ID})`,
                   function(err, result) {
      if (err) {
        console.log(err);
        return res.status(500).json({ error: 'Internal Server Error' });
      }
      
      console.log('Data inserted successfully:', result);
      res.status(200).json({ message: 'Data inserted successfully!' });
    });
  });
});

app.get('/api/manageemp', async (req, res) => {
  console.log('Received GET request at /api/manageemp');

  try {
      // Connect to SQL Server Database
      const pool = await sql.connect(dbConfig);
      console.log('Connected to SQL Server Database');

      // Execute the query to retrieve all department details
      const result = await pool.request()
          .query('SELECT * FROM employee');

      // Release the connection
      sql.close();
      console.log('Connection closed successfully');

      if (result.recordset.length > 0) {
          // Send department details as JSON response
          res.status(200).json(result.recordset);
      } else {
          res.status(404).json({ error: 'No departments found' });
      }
  } catch (error) {
      console.error('Error:', error);

      // Send an error response
      res.status(500).json({ error: 'Internal Server Error' });
  }
});



app.post('/api/requirements', async (req, res) => {
  const { DEPT_ID, DESIGN_ID,JOB_DESC,skills, JOB_TITLE, NOV, priority, role, OPENING_DATE, CLOSING_DATE,qualification,experience } = req.body;
  try {
    // Connect to the database
    await sql.connect(dbConfig);
    // Insert requirement into requirements table
    await sql.query`INSERT INTO requirement ( DEPT_ID, DESIGN_ID, JOB_TITLE,JOB_DESC,skills, NOV, priority, role, OPENING_DATE, CLOSING_DATE,qualification,experience) VALUES ( ${DEPT_ID}, ${DESIGN_ID}, ${JOB_TITLE},${JOB_DESC}, ${skills}, ${NOV}, ${priority}, ${role}, ${OPENING_DATE}, ${CLOSING_DATE},${qualification},${experience})`;
    // Send success response
    res.status(201).json({ message: 'Requirement inserted successfully' });
  } catch (err) {
    console.error('Error inserting requirement:', err);
    res.status(500).json({ error: 'Internal Server Error' });
  } finally {
    // Close the connection
    await sql.close();
  }
});






app.get('/api/managedesign', async (req, res) => {
  console.log('Received GET request at /api/managedesign');

  try {
      // Connect to SQL Server Database
      const pool = await sql.connect(dbConfig);
      console.log('Connected to SQL Server Database');

      // Execute the query to retrieve all department details
      const result = await pool.request()
          .query('SELECT * FROM designation');

      // Release the connection
      sql.close();
      console.log('Connection closed successfully');

      if (result.recordset.length > 0) {
          // Send department details as JSON response
          res.status(200).json(result.recordset);
      } else {
          res.status(404).json({ error: 'No departments found' });
      }
  } catch (error) {
      console.error('Error:', error);

      // Send an error response
      res.status(500).json({ error: 'Internal Server Error' });
  }
});




app.post('/api/adddes', (req, res) => {
  const { DESIGN_NAME, DESIGN_DESC, MIN_EXP, MAX_EXP, QUALIFICATION} = req.body;

  sql.connect(dbConfig, function(err) {
    if (err) {
      console.log(err);
      return res.status(500).json({ error: 'Internal Server Error' });
    }

    var request = new sql.Request();
    request.query(`INSERT INTO designation (DESIGN_NAME, DESIGN_DESC,MIN_EXP,MAX_EXP,QUALIFICATION) 
                   VALUES ('${DESIGN_NAME}', '${DESIGN_DESC}', ${MIN_EXP}, ${MAX_EXP}, '${QUALIFICATION}')`,
                   function(err, result) {
      if (err) {
        console.log(err);
        return res.status(500).json({ error: 'Internal Server Error' });
      }
      
      console.log('Data inserted successfully:', result);
      res.status(200).json({ message: 'Data inserted successfully!' });
    });
  });
});




// Login route
app.get('/api/loginret/:uname/:password', async (req, res) => {
  console.log('Received GET request at /api/loginret/:uname/:password');
  const uname = req.params.uname;
  const password = req.params.password;

  try {
    // Connect to SQL Server Database
    const pool = await sql.connect(dbConfig);
    console.log('Connected to SQL Server Database');

    // Execute the query to retrieve company details by ID
    const result = await pool.request()
      .input('uname', sql.VarChar, uname)
      .input('password', sql.VarChar, password)
      .query('SELECT * FROM candidate WHERE u_name = @uname and password= @password');

    // Release the connection
    sql.close();
    console.log('Connection closed successfully');

    if (result.recordset.length > 0) {
      // Construct JSON response with column names and values
      const CandDetails = result.recordset[0];
      
      // Send company details as JSON response
      res.status(200).json(CandDetails);
    } else {
      res.status(404).json({ error: 'Company not found' });
    }
  } catch (error) {
    console.error('Error:', error);

    // Send an error response
    res.status(500).json({ error: 'Internal Server Error' });
  }
});



app.get('/api/requirements', async (req, res) => {
  console.log('Received GET request at /api/requirements');

  try {
      // Connect to SQL Server Database
      const pool = await sql.connect(dbConfig);
      console.log('Connected to SQL Server Database');

      // Execute the query to retrieve all department details
      const result = await pool.request()
          .query('SELECT JOB_ID,JOB_TITLE,DEPT_ID,DESIGN_ID,NOV,priority,role,OPENING_DATE,CLOSING_DATE FROM requirement');

      // Release the connection
      sql.close();
      console.log('Connection closed successfully');

      if (result.recordset.length > 0) {
          // Send department details as JSON response
          res.status(200).json(result.recordset);
      } else {
          res.status(404).json({ error: 'No departments found' });
      }
  } catch (error) {
      console.error('Error:', error);

      // Send an error response
      res.status(500).json({ error: 'Internal Server Error' });
  }
});







app.put('/api/approve/:requirementId', async (req, res) => {
  const requirementId = req.params.requirementId;
  const approvalStatus = 'Approved'; // You can customize this based on your requirement

  try {
    await sql.connect(dbConfig);
    const result = await sql.query`UPDATE requirement SET APPROVED_BY_MANAGER = ${approvalStatus} WHERE JOB_ID = ${requirementId}`;
    await sql.close();
    console.log(`Requirement with ID ${requirementId} approved successfully`);
    res.status(200).send(`Requirement with ID ${requirementId} approved successfully`);
  } catch (error) {
    console.error('Error updating approval status:', error);
    res.status(500).send('Failed to update approval status');
  }
});

app.put('/api/reject/:requirementId', async (req, res) => {
  const requirementId = req.params.requirementId;
  const approvalStatus = 'Rejected'; // You can customize this based on your requirement

  try {
    await sql.connect(dbConfig);
    const result = await sql.query`UPDATE requirement SET APPROVED_BY_MANAGER = ${approvalStatus} WHERE JOB_ID = ${requirementId}`;
    await sql.close();
    console.log(`Requirement with ID ${requirementId} rejected successfully`);
    res.status(200).send(`Requirement with ID ${requirementId} rejected successfully`);
  } catch (error) {
    console.error('Error updating approval status:', error);
    res.status(500).send('Failed to update approval status');
  }
});


// Endpoint to fetch approval status
app.get('/api/approval/:requirementId', async (req, res) => {
  const requirementId = req.params.requirementId;

  try {
    await sql.connect(dbConfig);
    const result = await sql.query`SELECT APPROVED_BY_MANAGER FROM requirement WHERE JOB_ID = ${requirementId}`;
    await sql.close();

    if (result.recordset.length > 0) {
      const approvalStatus = result.recordset[0].APPROVED_BY_MANAGER;
      console.log(`Approval status for application ID ${requirementId}: ${approvalStatus}`);
      res.status(200).send(approvalStatus);
    } else {
      console.log('No data found for the specified application ID');
      res.status(404).send('No data found for the specified application ID');
    }
  } catch (error) {
    console.error('Error fetching approval status:', error);
    res.status(500).send('Failed to fetch approval status');
  }
});





app.get('/api/approvedRequirements', async (req, res) => {
  try {
    // Connect to the database
    await sql.connect(dbConfig);

    // Query to retrieve approved requirements
    const result = await sql.query`
      SELECT *
      FROM requirement
      WHERE APPROVED_BY_MANAGER = 'Approved';
    `;

    // Send the retrieved rows as JSON
    res.json(result.recordset);

  } catch (err) {
    // Handle errors
    console.error('Error executing query:', err);
    res.status(500).json({ error: 'Failed to retrieve approved requirements' });
  } finally {
    // Close the connection
    sql.close();
  }
});





app.put('/api/approved/:requirementId', async (req, res) => {
  const requirementId = req.params.requirementId;
  const approvalStatus = 'Approved'; // You can customize this based on your requirement

  try {
    await sql.connect(dbConfig);
    const result = await sql.query`UPDATE requirement SET APPROVED_BY_HR = ${approvalStatus} WHERE JOB_ID = ${requirementId}`;
    await sql.close();
    console.log(`Requirement with ID ${requirementId} approved successfully by HR`);
    res.status(200).send(`Requirement with ID ${requirementId} approved successfully by HR`);
  } catch (error) {
    console.error('Error updating approval status:', error);
    res.status(500).send('Failed to update approval status');
  }
});

app.put('/api/rejected/:requirementId', async (req, res) => {
  const requirementId = req.params.requirementId;
  const approvalStatus = 'Rejected'; // You can customize this based on your requirement

  try {
    await sql.connect(dbConfig);
    const result = await sql.query`UPDATE requirement SET APPROVED_BY_HR = ${approvalStatus} WHERE JOB_ID = ${requirementId}`;
    await sql.close();
    console.log(`Requirement with ID ${requirementId} rejected successfully by HR`);
    res.status(200).send(`Requirement with ID ${requirementId} rejected successfully by HR`);
  } catch (error) {
    console.error('Error updating approval status:', error);
    res.status(500).send('Failed to update approval status');
  }
});





// Endpoint to fetch approval status
app.get('/api/approval/:requirementId', async (req, res) => {
  const requirementId = req.params.requirementId;

  try {
    await sql.connect(dbConfig);
    const result = await sql.query`SELECT APPROVED_BY_HR FROM requirement WHERE JOB_ID = ${requirementId}`;
    await sql.close();

    if (result.recordset.length > 0) {
      const approvalStatus = result.recordset[0].APPROVED_BY_HR;
      console.log(`Approval status for application ID ${requirementId}: ${approvalStatus}`);
      res.status(200).send(approvalStatus);
    } else {
      console.log('No data found for the specified application ID');
      res.status(404).send('No data found for the specified application ID');
    }
  } catch (error) {
    console.error('Error fetching approval status:', error);
    res.status(500).send('Failed to fetch approval status');
  }
});





app.get('/api/approvedRequirementss', async (req, res) => {
  try {
    // Connect to the database
    await sql.connect(dbConfig);

    // Query to retrieve approved requirements
    const result = await sql.query`
      SELECT *
      FROM requirement
      WHERE APPROVED_BY_HR = 'Approved';
    `;

    // Send the retrieved rows as JSON
    res.json(result.recordset);

  } catch (err) {
    // Handle errors
    console.error('Error executing query:', err);
    res.status(500).json({ error: 'Failed to retrieve approved requirements' });
  } finally {
    // Close the connection
    sql.close();
  }
});



app.put('/api/post/:requirementId', async (req, res) => {
  const requirementId = req.params.requirementId;
  const approvalStatus = 'posted'; // You can customize this based on your requirement

  try {
    await sql.connect(dbConfig);
    const result = await sql.query`UPDATE requirement SET post = ${approvalStatus} WHERE JOB_ID = ${requirementId}`;
    await sql.close();
    console.log(`Requirement with ID ${requirementId} approved successfully by HR`);
    res.status(200).send(`Requirement with ID ${requirementId} approved successfully by HR`);
  } catch (error) {
    console.error('Error updating approval status:', error);
    res.status(500).send('Failed to update approval status');
  }
});




app.get('/api/approvedRequirementss', async (req, res) => {
  try {
    // Connect to the database
    await sql.connect(dbConfig);

    // Query to retrieve approved requirements
    const result = await sql.query`
      SELECT *
      FROM requirement
      WHERE post = 'posted';
    `;

    // Send the retrieved rows as JSON
    res.json(result.recordset);

  } catch (err) {
    // Handle errors
    console.error('Error executing query:', err);
    res.status(500).json({ error: 'Failed to retrieve approved requirements' });
  } finally {
    // Close the connection
    sql.close();
  }
});







app.use(bodyParser.json());

// Route for handling resume URL upload
app.post('/upload', async (req, res) => {
  try {
    const { resumeUrl } = req.body;
    if (!resumeUrl) {
      return res.status(400).json({ error: 'No resume URL provided' });
    }

    // Connect to the SQL Server database
    await sql.connect(dbConfig);

    // Insert the resume URL into the database table
    const request = new sql.Request();
    const query = `
      INSERT INTO Resumes (ResumeUrl)
      VALUES (@resumeUrl)
    `;
    request.input('resumeUrl', sql.NVarChar, resumeUrl);
    await request.query(query);

    // Respond with a success message
    res.status(200).json({ message: 'Resume URL uploaded successfully' });
  } catch (error) {
    console.error('Error uploading resume URL:', error);
    res.status(500).json({ error: 'Failed to upload resume URL' });
  }
});



app.get('/api/check-application', async (req, res) => {
  try {
    await sql.connect(dbConfig);
    console.log('Connected to SQL Server database');

    const candidateId = req.query.candidateId;
    const jobId = parseInt(req.query.jobId);

    // Query the database to check if an application exists
    const result = await sql.query`SELECT * FROM application WHERE candidate_id = ${candidateId} AND JOB_ID = ${jobId}`;

    // Check if an application exists based on the query results
    if (result.recordset.length > 0) {
      res.status(200).json({ exists: true });
    } else {
      res.status(200).json({ exists: false });
    }

    // Close the database connection
    await sql.close();
  } catch (err) {
    console.error('Error querying database: ', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});



app.post('/uploads', async (req, res) => {
  try {
    const { candidate_id, resume, full_name, address1, address2, qualification, JOB_ID,JOB_TITLE,DEPT_ID } = req.body;
    if (!candidate_id || !resume || !full_name || !address1 || !address2 || !qualification||!JOB_ID|| !JOB_TITLE|| !DEPT_ID ){
      return res.status(400).json({ error: 'All fields are required' });
    }

    // Connect to the SQL Server database
    await sql.connect(dbConfig);

    // Insert the resume details into the database table
    const request = new sql.Request();
    const query = `
      INSERT INTO application (candidate_id, resume, full_name, address1, address2, qualification, JOB_ID, JOB_TITLE,DEPT_ID)
      VALUES (@candidate_id, @resume, @full_name, @address1, @address2, @qualification, @JOB_ID, @JOB_TITLE,@DEPT_ID)
    `;
    request.input('candidate_id', sql.NVarChar, candidate_id);
    request.input('DEPT_ID', sql.NVarChar, DEPT_ID);
    request.input('resume', sql.NVarChar, resume);
    request.input('full_name', sql.NVarChar, full_name);
    request.input('address1', sql.NVarChar, address1);
    request.input('address2', sql.NVarChar, address2);
    request.input('qualification', sql.NVarChar, qualification);
    request.input('JOB_ID', sql.NVarChar, JOB_ID);
    request.input('JOB_TITLE', sql.NVarChar, JOB_TITLE);

    await request.query(query);

    // Respond with a success message
    res.status(200).json({ message: 'Resume details uploaded successfully' });
  } catch (error) {
    console.error('Error uploading resume details:', error);
    res.status(500).json({ error: 'Failed to upload resume details' });
  }
});


app.get('/get-department', (req, res) => {
  const jobId = req.query.jobId;
  const job = jobData[jobId];

  if (!job) {
    return res.status(404).json({ error: 'Job not found' });
  }

  const deptId = job.deptId;
  const department = department[deptId];

  if (!department) {
    return res.status(404).json({ error: 'Department not found' });
  }

  // Return department details
  res.json({ DEPT_ID: department.deptId, DEPT_NAME: department.deptName });
});




app.get('/api/applicants', async (req, res) => {
  try {
    // Connect to the database
    await sql.connect(dbConfig);

    // Query to retrieve approved requirements
    const result = await sql.query`
      SELECT *
      FROM application;
    `;

    // Send the retrieved rows as JSON
    res.json(result.recordset);

  } catch (err) {
    // Handle errors
    console.error('Error executing query:', err);
    res.status(500).json({ error: 'Failed to retrieve approved requirements' });
  } finally {
    // Close the connection
    sql.close();
  }
});



app.get('/api/applicantss/:candidateId', async (req, res) => {
  const candidateId = parseInt(req.params.candidateId); // Convert to integer

  console.log('Received GET request for candidate ID:', req.params.candidateId); // Debugging

  try {
    console.log('Parsed candidate ID:', candidateId); // Debugging

    // Check if candidateId is a valid number
    if (isNaN(candidateId)) {
      return res.status(400).json({ error: 'Invalid candidate ID' });
    }

    // Connect to SQL Server Database
    const pool = await sql.connect(dbConfig);
    console.log('Connected to SQL Server Database');

    // Execute the query to retrieve applications for the specific candidate
    const result = await pool.request()
      .input('candidateId', sql.Int, candidateId)
      .query('SELECT * FROM application WHERE candidate_id = @candidateId');

    // Release the connection
    await pool.close();
    console.log('Connection closed successfully');

    if (result.recordset.length > 0) {
      // Send applications as JSON response
      res.status(200).json(result.recordset);
    } else {
      res.status(404).json({ error: 'No applications found for the candidate' });
    }
    
  } catch (error) {
    console.error('Error:', error);
    // Send an error response
    res.status(500).json({ error: 'Internal Server Error' });
  }
});








app.put('/api/selecta/:candidateId/:jobId', async (req, res) => {
  const { candidateId, jobId } = req.params;
  const approvalStatus = 'Approved'; // You can customize this based on your requirement

  try {
    await sql.connect(dbConfig);
    const result = await sql.query`UPDATE application SET status = ${approvalStatus} WHERE candidate_id = ${candidateId} AND JOB_ID = ${jobId}`;
    await sql.close();
    console.log(`Job ${jobId} of candidate ${candidateId} approved successfully by HR`);
    res.status(200).send(`Job ${jobId} of candidate ${candidateId} approved successfully by HR`);
  } catch (error) {
    console.error('Error updating approval status:', error);
    res.status(500).send('Failed to update approval status');
  }
});

app.put('/api/rejecta/:candidateId/:jobId', async (req, res) => {
  const { candidateId, jobId } = req.params;
  const approvalStatus = 'Rejected'; // You can customize this based on your requirement

  try {
    await sql.connect(dbConfig);
    const result = await sql.query`UPDATE application SET status = ${approvalStatus} WHERE candidate_id = ${candidateId} AND JOB_ID = ${jobId}`;
    await sql.close();
    console.log(`Job ${jobId} of candidate ${candidateId} rejected successfully by HR`);
    res.status(200).send(`Job ${jobId} of candidate ${candidateId} rejected successfully by HR`);
  } catch (error) {
    console.error('Error updating approval status:', error);
    res.status(500).send('Failed to update approval status');
  }
});




app.get('/interview', async (req, res) => {
  try {
    // Connect to the database
    await sql.connect(dbConfig);

    // Query to fetch applications with the status 'Approved'
    const result = await sql.query`SELECT * FROM application WHERE status = 'Approved'`;

    // Send the results as JSON response
    res.json(result.recordset);
  } catch (err) {
    console.error('Error fetching approved applications: ', err);
    res.status(500).json({ error: 'Internal Server Error' });
  } finally {
    // Close the database connection
    sql.close();
  }
});




/*app.post('/insert-interview', async (req, res) => {
  const interviewData = req.body;

  try {
    // Connect to the database
    await sql.connect(dbConfig);

    // Prepare SQL query
    const result = await sql.query(`
      INSERT INTO interview (candidate_id, app_id, full_name, JOB_TITLE, interview_level, DEPT_ID, interview_date)
      VALUES (@candidate_id, @app_id, @full_name, @JOB_TITLE, @interview_level, @DEPT_ID, @interview_date)
    `, {
      candidate_id: sql.Int,
      app_id: sql.Int,
      full_name: sql.NVarChar,
      JOB_TITLE: sql.NVarChar,
      interview_level: sql.NVarChar,
      DEPT_ID: sql.Int,
      interview_date: sql.DateTime
    });

    console.log('Interview inserted successfully');
    res.status(200).send('Interview inserted successfully');
  } catch (err) {
    console.error('Error inserting interview:', err);
    res.status(500).send('Error inserting interview');
  } finally {
    // Close database connection
    await sql.close();
  }
});*/


const insertInterviewQuery = `
  INSERT INTO interview (candidate_id, app_id, full_name, JOB_TITLE, DEPT_ID, interview_level, interview_date, interview_time)
  VALUES (@candidate_id, @app_id, @full_name, @JOB_TITLE, @DEPT_ID, @interview_level, @interview_date, @interview_time)
`;

// API endpoint for adding an interview
app.post('/api/addinterview', (req, res) => {
  const { candidate_id, app_id, DEPT_ID, full_name, JOB_TITLE, interview_level, interview_date, interview_time } = req.body;

  // Connect to the database
  sql.connect(dbConfig, (err) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ error: 'Internal Server Error' });
    }

    // Check if an interview already exists for the candidate and job
    const checkExistingInterviewQuery = `
      SELECT COUNT(*) AS count
      FROM interview
      WHERE candidate_id = @candidate_id
      AND app_id = @app_id
    `;

    const requestCheck = new sql.Request();
    requestCheck.input('candidate_id', sql.NVarChar, candidate_id)
                .input('app_id', sql.NVarChar, app_id)
                .query(checkExistingInterviewQuery, (err, result) => {
      if (err) {
        console.error(err);
        return res.status(500).json({ error: 'Internal Server Error' });
      }

      if (result.recordset[0].count > 0) {
        return res.status(400).json({ error: 'Candidate has already scheduled an interview for this job.' });
      }

      const indianDate = moment(interview_date).tz('Asia/Kolkata').format('YYYY-MM-DD');
      const indianTime = moment(interview_time, 'HH:mm').tz('Asia/Kolkata').format('HH:mm:ss');

      // Then use the parsed date and time for the SQL query
      const requestInsert = new sql.Request();
      requestInsert.input('candidate_id', sql.NVarChar, candidate_id)
          .input('app_id', sql.NVarChar, app_id)
          .input('full_name', sql.NVarChar, full_name)
          .input('JOB_TITLE', sql.NVarChar, JOB_TITLE)
          .input('DEPT_ID', sql.NVarChar, DEPT_ID)
          .input('interview_level', sql.NVarChar, interview_level)
          .input('interview_date', sql.NVarChar, indianDate)
          .input('interview_time', sql.NVarChar, indianTime)
          .query(insertInterviewQuery, (err, result) => {
              if (err) {
                  console.error(err);
                  return res.status(500).json({ error: 'Internal Server Error' });
              }

              console.log('Interview inserted successfully:', result);
              res.status(200).json({ message: 'Interview inserted successfully!' });
          });
    });
  });
});


app.get('/api/interviews1', async (req, res) => {
  try {
    await sql.connect(dbConfig);
    const result = await sql.query`SELECT * FROM interview WHERE DEPT_ID = 1`;
    res.json(result.recordset);
  } catch (err) {
    console.error('Error occurred while fetching interview data:', err);
    res.status(500).json({ error: 'Internal server error' });
  } finally {
    await sql.close();
  }
});

app.get('/api/interviews2', async (req, res) => {
  try {
    await sql.connect(dbConfig);
    const result = await sql.query`SELECT * FROM interview WHERE DEPT_ID = 2`;
    res.json(result.recordset);
  } catch (err) {
    console.error('Error occurred while fetching interview data:', err);
    res.status(500).json({ error: 'Internal server error' });
  } finally {
    await sql.close();
  }
});

app.get('/api/interviews3', async (req, res) => {
  try {
    await sql.connect(dbConfig);
    const result = await sql.query`SELECT * FROM interview WHERE DEPT_ID = 3`;
    res.json(result.recordset);
  } catch (err) {
    console.error('Error occurred while fetching interview data:', err);
    res.status(500).json({ error: 'Internal server error' });
  } finally {
    await sql.close();
  }
});



app.put('/api/pass/:candidateId/:interviewId', async (req, res) => {
  const { candidateId, interviewId } = req.params;
  const passFailStatus = 'pass'; // Assuming 'pass' means the candidate passed the interview

  try {
    // Validate input parameters
    if (!candidateId || !interviewId) {
      throw new Error('Candidate ID and interview ID are required');
    }

    // Connect to the database
    await sql.connect(dbConfig);

    // Execute the SQL update query
    const result = await sql.query`UPDATE interview SET pass_fail = ${passFailStatus} WHERE candidate_id = ${candidateId} AND interview_id = ${interviewId}`;

    // Close the database connection
    await sql.close();

    // Check if any rows were affected
    if (result.rowsAffected[0] > 0) {
      console.log(`Interview ${interviewId} of candidate ${candidateId} marked as passed successfully`);
      res.status(200).json({ message: 'Interview status updated successfully' });
    } else {
      console.log(`No interview found for candidate ${candidateId} with ID ${interviewId}`);
      res.status(404).json({ error: 'Interview not found' });
    }
  } catch (error) {
    console.error('Error updating interview status:', error.message);
    res.status(500).json({ error: 'Failed to update interview status' });
  }
});


app.put('/api/fail/:candidateId/:interviewId', async (req, res) => {
  const { candidateId, interviewId } = req.params;
  const passFailStatus = 'fail'; // Assuming 'pass' means the candidate passed the interview

  try {
    // Validate input parameters
    if (!candidateId || !interviewId) {
      throw new Error('Candidate ID and interview ID are required');
    }

    // Connect to the database
    await sql.connect(dbConfig);

    // Execute the SQL update query
    const result = await sql.query`UPDATE interview SET pass_fail = ${passFailStatus} WHERE candidate_id = ${candidateId} AND interview_id = ${interviewId}`;

    // Close the database connection
    await sql.close();

    // Check if any rows were affected
    if (result.rowsAffected[0] > 0) {
      console.log(`Interview ${interviewId} of candidate ${candidateId} marked as passed successfully`);
      res.status(200).json({ message: 'Interview status updated successfully' });
    } else {
      console.log(`No interview found for candidate ${candidateId} with ID ${interviewId}`);
      res.status(404).json({ error: 'Interview not found' });
    }
  } catch (error) {
    console.error('Error updating interview status:', error.message);
    res.status(500).json({ error: 'Failed to update interview status' });
  }
});




app.get('/api/interviewss/:candidateId', async (req, res) => {
  const candidateId = parseInt(req.params.candidateId); // Convert to integer

  console.log('Received GET request for candidate ID:', req.params.candidateId); // Debugging

  try {
    console.log('Parsed candidate ID:', candidateId); // Debugging

    // Check if candidateId is a valid number
    if (isNaN(candidateId)) {
      return res.status(400).json({ error: 'Invalid candidate ID' });
    }

    // Connect to SQL Server Database
    const pool = await sql.connect(dbConfig);
    console.log('Connected to SQL Server Database');

    // Execute the query to retrieve applications for the specific candidate
    const result = await pool.request()
      .input('candidateId', sql.Int, candidateId)
      .query('SELECT * FROM interview WHERE candidate_id = @candidateId');

    // Release the connection
    await pool.close();
    console.log('Connection closed successfully');

    if (result.recordset.length > 0) {
      // Send applications as JSON response
      res.status(200).json(result.recordset);
    } else {
      res.status(404).json({ error: 'No applications found for the candidate' });
    }
  } catch (error) {
    console.error('Error:', error);
    // Send an error response
    res.status(500).json({ error: 'Internal Server Error' });
  }
});







app.get('/:candidateId', async (req, res) => {
  try {
    await sql.connect(dbConfig);
    const result = await sql.query`SELECT * FROM candidate WHERE candidate_id = ${req.params.candidateId}`;
    if (result.recordset.length > 0) {
      res.status(200).json(result.recordset[0]);
    } else {
      res.status(404).json({ message: 'Details not found' });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Internal server error' });
  } finally {
    sql.close();
  }
});

// Endpoint to save or update details
app.post('/details', async (req, res) => {
  try {
    await sql.connect(dbConfig);
    const request = new sql.Request();
    const { candidate_id, qualification, address, pincode, state, languages_known, skills} = req.body;
    
    let query = '';
    let parameters = [];
    
    if (candidate_id) {
      query = 'UPDATE candidate SET qualification = @qualification, address = @address, pincode = @pincode, state = @state, languages_known = @languages_known,skills=@skills WHERE candidate_id = @candidate_id';
      parameters = [
        { name: 'qualification', type: sql.VarChar, value: qualification },
        { name: 'address', type: sql.VarChar, value: address },
        { name: 'pincode', type: sql.VarChar, value: pincode },
        { name: 'state', type: sql.VarChar, value: state },
        { name: 'languages_known', type: sql.VarChar, value: languages_known },
        { name: 'candidate_id', type: sql.Int, value: candidate_id },
        { name: 'skills', type: sql.VarChar, value: skills }
      ];
    } else {
      query = 'INSERT INTO candidate (qualification, address, pincode, state, languages_known, skills) VALUES (@qualification, @address, @pincode, @state, @languages_known, @skills)';
      parameters = [
        { name: 'qualification', type: sql.VarChar, value: qualification },
        { name: 'address', type: sql.VarChar, value: address },
        { name: 'pincode', type: sql.VarChar, value: pincode },
        { name: 'state', type: sql.VarChar, value: state },
        { name: 'languages_known', type: sql.VarChar, value: languages_known },
        { name: 'skills', type: sql.VarChar, value: skills },
      ];
    }
    
    for (const param of parameters) {
      request.input(param.name, param.type, param.value);
    }
    
    await request.query(query);
    res.status(200).json({ message: 'Details saved successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Internal server error' });
  } finally {
    sql.close();
  }
});




app.listen(port, () => {
    console.log(`Server is running at http://192.168.1.211:${port}`);
  });