using Microsoft.Data.SqlClient;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

string conn = "Server=tcp:azr-db01-sql.database.windows.net,1433;Initial Catalog=azr-db01-db;User ID=azadmin;Password=!imsi00000000;Encrypt=True;";

app.MapGet("/", async () =>
{
var html = "<h2>Courses</h2><table border='1'><tr><th>Name</th><th>Description</th></tr>";

using (SqlConnection connection = new SqlConnection(conn))
{
    await connection.OpenAsync();
    var cmd = new SqlCommand("SELECT Name, Description FROM Courses", connection);
    var reader = await cmd.ExecuteReaderAsync();

    while (await reader.ReadAsync())
    {
        html += $"<tr><td>{reader["Name"]}</td><td>{reader["Description"]}</td></tr>";
    }
}

html += "</table>";
return Results.Content(html, "text/html");

});

app.Run();
