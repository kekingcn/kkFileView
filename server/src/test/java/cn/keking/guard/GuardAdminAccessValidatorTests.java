package cn.keking.guard;

import com.guardcore.protocols.GuardRequest;
import com.guardcore.protocols.GuardResponse;
import com.guardcore.protocols.RequestState;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;

import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertInstanceOf;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

class GuardAdminAccessValidatorTests {

    private static GuardRequest request(String clientIp, Map<String, String> headers) {
        GuardRequest request = mock(GuardRequest.class);
        RequestState state = mock(RequestState.class);
        when(state.getAttr("client_ip")).thenReturn(clientIp);
        when(request.getState()).thenReturn(state);
        when(request.getHeaders()).thenReturn(headers);
        return request;
    }

    private static Object validate(GuardAdminAccessValidator validator, String clientIp, Map<String, String> headers) {
        return validator.validate(request(clientIp, headers), null);
    }

    private static void assertForbidden(Object outcome) {
        GuardResponse response = assertInstanceOf(GuardResponse.class, outcome);
        assertEquals(403, response.getStatusCode());
    }

    @Test
    void allowsEveryoneWhenNothingIsConfigured() {
        GuardAdminAccessValidator validator = new GuardAdminAccessValidator(List.of(), "");
        assertNull(validate(validator, "198.51.100.1", Map.of()));
    }

    @Test
    void allowlistAcceptsAddressesAndCidrRangesOnly() {
        GuardAdminAccessValidator validator = new GuardAdminAccessValidator(List.of("10.0.0.0/8", "192.0.2.7", "2001:db8::/32"), "");
        assertNull(validate(validator, "10.200.3.4", Map.of()));
        assertNull(validate(validator, "192.0.2.7", Map.of()));
        assertNull(validate(validator, "2001:db8:1::5", Map.of()));
        assertForbidden(validate(validator, "11.0.0.1", Map.of()));
        assertForbidden(validate(validator, "192.0.2.8", Map.of()));
        assertForbidden(validate(validator, "2001:db9::1", Map.of()));
        assertForbidden(validate(validator, null, Map.of()));
        assertForbidden(validate(validator, "not-an-ip", Map.of()));
    }

    @Test
    void prefixesThatAreNotAMultipleOfEightBitsAreHonoured() {
        GuardAdminAccessValidator validator = new GuardAdminAccessValidator(List.of("172.16.0.0/12"), "");
        assertNull(validate(validator, "172.31.255.255", Map.of()));
        assertForbidden(validate(validator, "172.32.0.1", Map.of()));
    }

    @Test
    void anIpv4MappedIpv6PeerMatchesAnIpv4Entry() {
        GuardAdminAccessValidator validator = new GuardAdminAccessValidator(List.of("192.0.2.0/24"), "");
        assertNull(validate(validator, "::ffff:192.0.2.9", Map.of()));
    }

    @Test
    void keyMustMatchExactly() {
        GuardAdminAccessValidator validator = new GuardAdminAccessValidator(List.of(), "s3cret");
        assertNull(validate(validator, "198.51.100.1", Map.of("x-kk-admin-key", "s3cret")));
        assertForbidden(validate(validator, "198.51.100.1", Map.of()));
        assertForbidden(validate(validator, "198.51.100.1", Map.of("x-kk-admin-key", "s3cret ")));
        assertForbidden(validate(validator, "198.51.100.1", Map.of("x-kk-admin-key", "S3CRET")));
    }

    @Test
    void bothMustPassWhenBothAreConfigured() {
        GuardAdminAccessValidator validator = new GuardAdminAccessValidator(List.of("192.0.2.0/24"), "s3cret");
        assertNull(validate(validator, "192.0.2.9", Map.of("x-kk-admin-key", "s3cret")));
        assertForbidden(validate(validator, "192.0.2.9", Map.of()));
        assertForbidden(validate(validator, "198.51.100.1", Map.of("x-kk-admin-key", "s3cret")));
    }

    @ParameterizedTest
    @ValueSource(strings = {"10.0.0", "10.0.0.256", "10.0.0.0/33", "10.0.0.0/-1", "10.0.0.0/8/8", "example.com", "::1/129", "10.0.0.0/x"})
    void aMistypedEntryFailsStartup(String entry) {
        assertThrows(IllegalArgumentException.class, () -> new GuardAdminAccessValidator(List.of(entry), ""));
    }
}
