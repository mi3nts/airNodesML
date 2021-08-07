
% Define these variables appropriately:
mail = 'teamlary@yahoo.com'; %Your Yahoo email address
password = 'tly2yahoo';  %Your Yahoo password
setpref('Internet','SMTP_Server','smtp.mail.yahoo.com');

setpref('Internet','E_mail',mail);
setpref('Internet','SMTP_Username',mail);
setpref('Internet','SMTP_Password',password);
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth',                'true');  % Note: 'true' as a string, not a logical value!
props.setProperty('mail.smtp.starttls.enable',     'true');  % Note: 'true' as a string, not a logical value!
props.setProperty('mail.smtp.socketFactory.port',  '465');   % Note: '465'  as a string, not a numeric value!
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');

% Send the email.  Note that the first input is the address you are sending the email to
sendmail(mail,'Test from MATLAB','Hello! This is a test from MATLAB!')