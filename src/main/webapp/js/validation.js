/**
 * Digital Student Grievance & Feedback Portal - Form Validation Utilities
 */

// Email regex pattern
const EMAIL_REGEX = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;

function validateRegistrationForm() {
    const email = document.getElementById('email');
    const studentId = document.getElementById('studentId');
    const password = document.getElementById('password');
    const confirmPassword = document.getElementById('confirmPassword');
    const errorContainer = document.getElementById('formClientError');

    if (errorContainer) errorContainer.style.display = 'none';

    if (email && !EMAIL_REGEX.test(email.value.trim())) {
        showError('Please enter a valid academic email address.');
        email.focus();
        return false;
    }

    if (studentId && studentId.value.trim().length < 3) {
        showError('Please enter a valid Student Roll Number / ID.');
        studentId.focus();
        return false;
    }

    if (password && password.value.length < 6) {
        showError('Password must be at least 6 characters in length.');
        password.focus();
        return false;
    }

    if (password && confirmPassword && password.value !== confirmPassword.value) {
        showError('Password confirmation does not match the password.');
        confirmPassword.focus();
        return false;
    }

    return true;
}

function validateGrievanceForm() {
    const title = document.getElementById('title');
    const category = document.getElementById('category');
    const description = document.getElementById('description');

    if (title && title.value.trim().length < 5) {
        alert('Grievance title must be at least 5 characters long.');
        title.focus();
        return false;
    }

    if (category && (!category.value || category.value === '')) {
        alert('Please select an appropriate grievance category.');
        category.focus();
        return false;
    }

    if (description && description.value.trim().length < 10) {
        alert('Please provide a descriptive explanation of your grievance (at least 10 characters).');
        description.focus();
        return false;
    }

    return true;
}

function validateFeedbackForm() {
    const ratingInputs = document.querySelectorAll('input[name="rating"]:checked');
    const category = document.getElementById('feedbackCategory');
    const subject = document.getElementById('subject');
    const comments = document.getElementById('comments');

    if (ratingInputs.length === 0) {
        alert('Please select a star rating (1 to 5 stars) for your experience.');
        return false;
    }

    if (category && (!category.value || category.value === '')) {
        alert('Please select a facility or service category.');
        category.focus();
        return false;
    }

    if (subject && subject.value.trim().length < 3) {
        alert('Please provide a subject for your feedback.');
        subject.focus();
        return false;
    }

    if (comments && comments.value.trim().length < 5) {
        alert('Please enter detailed comments or suggestions (at least 5 characters).');
        comments.focus();
        return false;
    }

    return true;
}

function showError(msg) {
    const errorContainer = document.getElementById('formClientError');
    if (errorContainer) {
        errorContainer.textContent = msg;
        errorContainer.style.display = 'block';
    } else {
        alert(msg);
    }
}
