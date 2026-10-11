/**
 * Digital Student Grievance & Feedback Portal - Main Frontend JavaScript
 */

document.addEventListener('DOMContentLoaded', function () {
    // 1. Mobile Sidebar Toggle
    const mobileToggleBtn = document.getElementById('mobileToggleBtn');
    const sidebar = document.getElementById('sidebar');

    if (mobileToggleBtn && sidebar) {
        mobileToggleBtn.addEventListener('click', function () {
            sidebar.classList.toggle('open');
        });

        // Close sidebar on click outside in mobile view
        document.addEventListener('click', function (e) {
            if (window.innerWidth <= 992 &&
                sidebar.classList.contains('open') &&
                !sidebar.contains(e.target) &&
                !mobileToggleBtn.contains(e.target)) {
                sidebar.classList.remove('open');
            }
        });
    }

    // 2. Auto-dismiss Alert Messages after 6 seconds
    const alerts = document.querySelectorAll('.alert-dismissible');
    alerts.forEach(function (alert) {
        setTimeout(function () {
            alert.style.transition = 'opacity 0.4s ease, transform 0.4s ease';
            alert.style.opacity = '0';
            alert.style.transform = 'translateY(-8px)';
            setTimeout(function () {
                alert.remove();
            }, 400);
        }, 6000);
    });

    // 3. Interactive Star Rating Display Logic
    const starInputs = document.querySelectorAll('.star-rating input');
    const ratingFeedback = document.getElementById('ratingDescription');
    const ratingLabels = {
        '1': '1 Star - Poor / Needs Immediate Attention',
        '2': '2 Stars - Fair / Sub-par Experience',
        '3': '3 Stars - Average / Acceptable',
        '4': '4 Stars - Good / Well Maintained',
        '5': '5 Stars - Excellent / Highly Satisfied'
    };

    if (starInputs.length > 0 && ratingFeedback) {
        starInputs.forEach(function (input) {
            input.addEventListener('change', function () {
                ratingFeedback.textContent = ratingLabels[this.value] || '';
                ratingFeedback.style.color = '#d97706';
                ratingFeedback.style.fontWeight = '600';
            });
        });
    }

    // 4. Modal Window Controls
    window.openModal = function (modalId) {
        const modal = document.getElementById(modalId);
        if (modal) {
            modal.classList.add('active');
            document.body.style.overflow = 'hidden';
        }
    };

    window.closeModal = function (modalId) {
        const modal = document.getElementById(modalId);
        if (modal) {
            modal.classList.remove('active');
            document.body.style.overflow = '';
        }
    };

    // Close modal on background click
    const modals = document.querySelectorAll('.modal-overlay');
    modals.forEach(function (modal) {
        modal.addEventListener('click', function (e) {
            if (e.target === modal) {
                closeModal(modal.id);
            }
        });
    });

    // 5. Admin Status Update Modal Helper
    window.openUpdateModal = function (id, trackingId, currentStatus, currentResponse, dept) {
        const idInput = document.getElementById('modalGrievanceId');
        const trackingDisplay = document.getElementById('modalTrackingIdDisplay');
        const statusSelect = document.getElementById('modalStatusSelect');
        const responseText = document.getElementById('modalAdminResponse');
        const deptInput = document.getElementById('modalAssignedDepartment');

        if (idInput) idInput.value = id;
        if (trackingDisplay) trackingDisplay.textContent = trackingId;
        if (statusSelect) statusSelect.value = currentStatus;
        if (responseText) responseText.value = currentResponse || '';
        if (deptInput) deptInput.value = dept || '';

        openModal('updateGrievanceModal');
    };
});
